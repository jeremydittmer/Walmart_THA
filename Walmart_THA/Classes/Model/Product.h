//
//  Product.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/18/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSString *longDescription;
@property (nonatomic, copy) NSString *currencyString;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *productImageUrl;
@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic, assign) CGFloat reviewRating;
@property (nonatomic, assign) NSUInteger reviewCount;
@property (nonatomic, assign) BOOL inStock;

@end
