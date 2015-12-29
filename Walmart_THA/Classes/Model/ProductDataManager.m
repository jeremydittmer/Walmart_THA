//
//  ProductDataManager.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import "ProductDataManager.h"
#import "ProductJSONReader.h"
#import "Product.h"
#import "WalmartAPIManager.h"


NSString * const kNewProductsLoadedNotification = @"kNewProductsLoadedNotification";
NSString * const kProductImageLoadedNotification = @"kProductImageLoadedNotification";
NSString * const kProductIndexKey = @"kProductIndexKey";

NSString * const kBadHttpStatusError = @"kBadHttpStatusError";
NSString * const kJsonParsingError = @"kJsonParsingError";
NSString * const kApiCallFailedError = @"kApiCallFailedError";
NSString * const kErrorDataKey = @"kErrorDataKey";
NSString * const kHttpStatusKey = @"kHttpStatusKey";


CGFloat const kImageEdgeSize = 400.0;


@interface ProductDataManager ()

@property (nonatomic, strong) WalmartAPIManager *walmartApiManager;

@end


@implementation ProductDataManager

+ (instancetype)sharedInstance {
    static ProductDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProductDataManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.products = [NSMutableArray array];
        self.totalProducts = 0;
        self.allProductsLoaded = NO;
        
        self.walmartApiManager = [[WalmartAPIManager alloc] init];
        self.walmartApiManager.delegate = self;
    }
    return self;
}

- (void)getMoreProductsFromStartingIndex:(NSUInteger)startingIndex {
    
    // Guard against attempting API call for products that have already been loaded
    if (startingIndex >= [self.products count]) {
        [self.walmartApiManager getProductsFromStartingIndex:[self.products count]];
    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES, image);
                               } else {
                                   completionBlock(NO, nil);
                               }
                           }];
}

#pragma mark - WalmartAPIManagerDelegate

- (void)receivedWalmartAPIResponseJSON:(NSData *)objectNotation {
    NSError *error = nil;

    NSUInteger responseStatus = [ProductJSONReader responseStatusFromJSON:objectNotation error:&error];
    if (responseStatus != 200) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:responseStatus] forKey:kHttpStatusKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBadHttpStatusError object:self userInfo:dataDict];
    }
    else {
        NSArray *receivedProducts;
        if (error == nil) {
            receivedProducts = [ProductJSONReader productsFromJSON:objectNotation error:&error];
        }
        
        if (error == nil) {
            self.totalProducts = [ProductJSONReader totalProductsCountFromJSON:objectNotation error:&error];
            if (self.totalProducts == [self.products count]) {
                self.allProductsLoaded = YES;
            }
        }
        
        NSUInteger startingIndexForRequest = 0;
        if (error == nil) {
            startingIndexForRequest = [ProductJSONReader pageNumberFromJSON:objectNotation error:&error];
        }
        
        if (error == nil) {
            // Outer conditional tests to ensure that the response coming back includes the correct records
            // that should be appended to the existing list.  It's unlikely that we would get back a duplicate set
            // of products that we already have but this should guard against that remote chance.
            if (startingIndexForRequest == [self.products count]) {
                for (Product *receivedProduct in receivedProducts) {
                    
                    NSUInteger productIndex = [self.products count];
                    [self.products addObject:receivedProduct];
                    
                    NSURL *imageNSURL = [NSURL URLWithString:[receivedProduct.productImageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                    
                    [self downloadImageWithURL:imageNSURL completionBlock:^(BOOL succeeded, UIImage *image) {
                        if (succeeded) {
                            // Copying the received image significantly reduces the memory footprint of the saved images.  Saving a smaller image as a thumbnail (larger image could then be loaded asynchronously in Item Detail view from disk or URL) didn't result in significant memory savings.  For longer lists an image cache might be worth exploring.  I intentionally did not use a URL key/value cache here because real lists would consist of many different images, not the same 10 images used over and over.
                            CGSize newSize = CGSizeMake(kImageEdgeSize, kImageEdgeSize);
                            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
                            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            receivedProduct.productImage = newImage;
                            
                            NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:productIndex] forKey:kProductIndexKey];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kProductImageLoadedNotification object:self userInfo:dataDict];
                        }
                    }];
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewProductsLoadedNotification object:self];
            }
        }
        else {
            NSDictionary *dataDict = [NSDictionary dictionaryWithObject:error forKey:kErrorDataKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kJsonParsingError object:self userInfo:dataDict];
        }
    }
}

- (void)WalmartAPICallFailedWithError:(NSError *)error {    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:error forKey:kErrorDataKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kApiCallFailedError object:self userInfo:dataDict];
}


@end
