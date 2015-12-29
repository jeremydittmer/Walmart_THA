//
//  MainDetailViewCell.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import "MainDetailViewCell.h"

#import "UIColor+ColorExtensions.h"

@implementation MainDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self createConstraints];
    }
    return self;
}

- (void)createSubviews {
    
    self.productNameLabel = [[UILabel alloc] init];
    self.productNameLabel.textColor = [UIColor walmartDarkGrayColor];
    self.productNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
    self.productNameLabel.textAlignment = NSTextAlignmentLeft;
    self.productNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.productNameLabel.numberOfLines = 0;
    self.productNameLabel.translatesAutoresizingMaskIntoConstraints = NO;    
    [self.contentView addSubview:self.productNameLabel];
    
    self.starRatingView = [[StarRatingView alloc] init];
    self.starRatingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.starRatingView];
    
    self.productImageView = [[UIImageView alloc] init];
    self.productImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.productImageView];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = @"Price";
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.numberOfLines = 1;
    self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    self.priceLabel.textColor = [UIColor walmartDarkGrayColor];
    self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.priceLabel];
    
    self.priceView = [[VariableFontSizePriceView alloc] init];
    self.priceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.priceView];
}

- (void)createConstraints {

    NSDictionary *viewDict = @{
                               @"productNameLabel" : self.productNameLabel,
                               @"starRatingView" : self.starRatingView,
                               @"productImageView" : self.productImageView,
                               @"priceLabel" : self.priceLabel,
                               @"priceView" : self.priceView
                               };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[productNameLabel]-|" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[starRatingView]" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[priceLabel]" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[priceView]-|" options:0 metrics:nil views:viewDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.productImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:240.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.productImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.productImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.productImageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[productNameLabel]-[starRatingView]-0@500-[productImageView][priceLabel]-|" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.priceView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.priceLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:-3.0]];
}

@end