//
//  ProductJSONReader.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import "ProductJSONReader.h"
#import "Product.h"

@implementation ProductJSONReader

+ (NSUInteger)responseStatusFromJSON:(NSData *)objectNotation error:(NSError **)error {
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return 0;
    }
    
    return [[parsedObject valueForKey:@"status"] unsignedIntegerValue];
}

+ (NSUInteger)pageNumberFromJSON:(NSData *)objectNotation error:(NSError **)error {

    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return 0;
    }
    
    return [[parsedObject valueForKey:@"pageNumber"] unsignedIntegerValue];
}

+ (NSUInteger)totalProductsCountFromJSON:(NSData *)objectNotation error:(NSError **)error {

    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return 0;
    }
    
    return [[parsedObject valueForKey:@"totalProducts"] unsignedIntegerValue];
}

+ (NSArray *)productsFromJSON:(NSData *)objectNotation error:(NSError **)error {

    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *products = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"products"];
    
    for (NSDictionary *productDict in results) {
        Product *product = [[Product alloc] init];
        
        for (NSString *key in productDict) {
            
            // There are more compact ways to do this but they assume the JSON keys will match the @property names of the Product object.  If anything were to change, things would break so instead, this section explicitly shows how the JSON keys map to the model object properties.
            if ([key  isEqualToString:@"productId"]) {
                product.productId = [productDict valueForKey:key];
            }
            else if ([key isEqualToString:@"productName"]) {
                product.productName = [self removeInvalidCharactersFromString:[productDict valueForKey:key]];
            }
            else if ([key isEqualToString:@"shortDescription"]) {
                product.shortDescription = [self removeInvalidCharactersFromString:[productDict valueForKey:key]];
            }
            else if ([key isEqualToString:@"longDescription"]) {
                product.longDescription = [self removeInvalidCharactersFromString:[productDict valueForKey:key]];
            }
            else if ([key isEqualToString:@"price"]) {
                NSLocale *priceLocale = [NSLocale currentLocale];
                NSString *priceString = [productDict valueForKey:key];
                product.currencyString = [priceString substringToIndex:1];
                NSString *thousandSeparator = [priceLocale objectForKey:NSLocaleGroupingSeparator];
                NSString *result = [[priceString substringFromIndex:1] stringByReplacingOccurrencesOfString:thousandSeparator withString:@""];
                NSDecimalNumber *priceValue = [NSDecimalNumber decimalNumberWithString:result locale:priceLocale];
                product.price = priceValue;
            }
            else if ([key isEqualToString:@"productImage"]) {
                product.productImageUrl = [productDict valueForKey:key];
            }
            else if ([key isEqualToString:@"reviewRating"]) {
                product.reviewRating = [[productDict valueForKey:key] floatValue];
            }
            else if ([key isEqualToString:@"reviewCount"]) {
                product.reviewCount = [[productDict valueForKey:key] unsignedIntValue];
            }
            else if ([key isEqualToString:@"inStock"]) {
                product.inStock = [[productDict valueForKey:key] boolValue];
            }
        }
        [products addObject:product];
    }
    return products;
}

+ (NSString *)removeInvalidCharactersFromString:(NSString *)inString {
    return [inString stringByReplacingOccurrencesOfString:@"�" withString:@""];
}

@end
