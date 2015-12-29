//
//  WalmartAPIMockData.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/28/15.
//
//

#import <Foundation/Foundation.h>

@interface WalmartAPIMockData : NSObject

- (NSData *)getMockJSONDataForProductsFromStartingIndex:(NSUInteger)startingIndex pageSize:(NSUInteger)pageSize;

@end
