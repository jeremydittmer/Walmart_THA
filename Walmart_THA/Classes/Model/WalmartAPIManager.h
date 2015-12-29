//
//  WalmartAPIManager.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import <Foundation/Foundation.h>
#import "WalmartAPIManagerDelegate.h"

@interface WalmartAPIManager : NSObject
@property (nonatomic, weak) id<WalmartAPIManagerDelegate> delegate;

- (void)getProductsFromStartingIndex:(NSUInteger)startingIndex;
- (void)getProductsFromStartingIndex:(NSUInteger)startingIndex pageSize:(NSUInteger)pageSize;

@end
