//
//  ProductDataManager.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WalmartAPIManagerDelegate.h"

extern NSString * const kNewProductsLoadedNotification;
extern NSString * const kProductImageLoadedNotification;
extern NSString * const kProductIndexKey;

extern NSString * const kBadHttpStatusError;
extern NSString * const kJsonParsingError;
extern NSString * const kApiCallFailedError;
extern NSString * const kErrorDataKey;
extern NSString * const kHttpStatusKey;


@class WalmartAPIManager;

@interface ProductDataManager : NSObject<WalmartAPIManagerDelegate>

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, assign) NSUInteger totalProducts;
@property (nonatomic, assign) BOOL allProductsLoaded;

// Singleton
+ (id)sharedInstance;

- (void)getMoreProductsFromStartingIndex:(NSUInteger)startingIndex;
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end