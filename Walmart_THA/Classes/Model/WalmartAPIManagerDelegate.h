//
//  WalmartAPIManagerDelegate.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import <Foundation/Foundation.h>

@protocol WalmartAPIManagerDelegate <NSObject>

- (void)receivedWalmartAPIResponseJSON:(NSData *)objectNotation;
- (void)WalmartAPICallFailedWithError:(NSError *)error;

@end
