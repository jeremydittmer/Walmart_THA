//
//  ProductListTableViewCell.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/16/15.
//
//

#import <UIKit/UIKit.h>
#import "VariableFontSizePriceView.h"
#import "StarRatingView.h"

extern CGFloat const kProductListTableRowHeight;

@interface ProductListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) VariableFontSizePriceView *priceView;
@property (nonatomic, strong) StarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *inStockStatusLabel;
@property (nonatomic, assign) BOOL inStock;

@end