//
//  WalmartAPIManager.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import "WalmartAPIManager.h"
#import "WalmartAPIManagerDelegate.h"
#import "WalmartAPIMockData.h"

NSString * const WALMART_API_PATH = @"https://walmartlabs-test.appspot.com/_ah/api/walmart/v1/walmartproducts/";
NSString * const WALMART_API_KEY = @"06076dd0-8675-4616-a46b-a609488e3710";
NSUInteger const MAX_PAGE_SIZE = 30;
BOOL const USE_MOCK_DATA = YES;
float const DELAY_IN_SECONDS_FOR_MOCK_DATA_REPSONSE = 0.5;


@interface WalmartAPIManager () {
    WalmartAPIMockData *_mockData;
}
@end


@implementation WalmartAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (USE_MOCK_DATA) {
            _mockData = [[WalmartAPIMockData alloc] init];
        }
    }
    return self;
}

- (void)getProductsFromStartingIndex:(NSUInteger)startingIndex {
    [self getProductsFromStartingIndex:startingIndex pageSize:MAX_PAGE_SIZE];
}

- (void)getProductsFromStartingIndex:(NSUInteger)startingIndex pageSize:(NSUInteger)pageSize {
    
    if (!USE_MOCK_DATA) {
        NSString *urlAsString = [NSString stringWithFormat:@"%@%@/%lu/%lu", WALMART_API_PATH, WALMART_API_KEY, startingIndex, pageSize];
        NSURL *url = [[NSURL alloc] initWithString:urlAsString];
        [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                [self.delegate WalmartAPICallFailedWithError:error];
            } else {
                [self.delegate receivedWalmartAPIResponseJSON:data];
            }
        }];
    }
    else {
        NSData *mockJSONData = [_mockData getMockJSONDataForProductsFromStartingIndex:startingIndex pageSize:pageSize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, DELAY_IN_SECONDS_FOR_MOCK_DATA_REPSONSE * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.delegate receivedWalmartAPIResponseJSON:mockJSONData];
        });
    }
}

@end
