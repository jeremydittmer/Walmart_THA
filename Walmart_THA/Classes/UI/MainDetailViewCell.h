//
//  MainDetailViewCell.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"
#import "VariableFontSizePriceView.h"

@interface MainDetailViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) StarRatingView *starRatingView;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) VariableFontSizePriceView *priceView;

@end