//
//  WalmartAPIMockData.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/28/15.
//
//

#import "WalmartAPIMockData.h"

@interface WalmartAPIMockData ()

@property (nonatomic, strong) NSDictionary *parsedJSON;
@property (nonatomic, strong) NSArray *jsonProductArray;

@end

@implementation WalmartAPIMockData

- (instancetype)init {
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"product_data" ofType:@"json"];
        NSData *myJSON = [[NSFileManager defaultManager] contentsAtPath:filePath];
        self.parsedJSON = [NSJSONSerialization JSONObjectWithData:myJSON options:0 error:nil];
        self.jsonProductArray = [self.parsedJSON valueForKey:@"products"];
    }
    return self;
}

- (NSData *)getMockJSONDataForProductsFromStartingIndex:(NSUInteger)startingIndex pageSize:(NSUInteger)pageSize {
    
    NSUInteger totalProducts = [[self.parsedJSON valueForKey:@"totalProducts"] unsignedIntegerValue];
    if (startingIndex + pageSize > totalProducts) {
        pageSize = totalProducts - startingIndex;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [self.parsedJSON valueForKey:@"id"], @"id",
                          [self.jsonProductArray subarrayWithRange:NSMakeRange(startingIndex, pageSize)], @"products",
                          [self.parsedJSON valueForKey:@"totalProducts"], @"totalProducts",
                          [NSNumber numberWithUnsignedLong:startingIndex], @"pageNumber",
                          [NSNumber numberWithUnsignedLong:pageSize], @"pageSize",
                          [self.parsedJSON valueForKey:@"status"], @"status",
                          [self.parsedJSON valueForKey:@"kind"], @"kind",
                          [self.parsedJSON valueForKey:@"etag"], @"etag",
                          nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    return jsonData;
}

@end
