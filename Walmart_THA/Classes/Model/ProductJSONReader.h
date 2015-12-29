//
//  ProductJSONReader.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import <Foundation/Foundation.h>

@interface ProductJSONReader : NSObject

+ (NSUInteger)responseStatusFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSUInteger)pageNumberFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSUInteger)totalProductsCountFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSArray *)productsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
