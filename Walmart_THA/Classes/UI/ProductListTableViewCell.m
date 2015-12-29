//
//  ProductListTableViewCell.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/16/15.
//
//

#import "ProductListTableViewCell.h"
#import "UIColor+ColorExtensions.h"


CGFloat const kProductListTableRowHeight = 126.0;
CGFloat const kCellImageWidth = 88.0;


@implementation ProductListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self createConstraints];
    }
    return self;
}

// Override setter for inStock BOOL so that label text and color is changed when value of inStock is changed
- (void)setInStock:(BOOL)inStock {
    _inStock = inStock;
    if (_inStock) {
        self.inStockStatusLabel.text = @"In Stock";
        self.inStockStatusLabel.textColor = [UIColor walmartGreenColor];
    }
    else {
        self.inStockStatusLabel.text = @"Out of Stock";
        self.inStockStatusLabel.textColor = [UIColor walmartRedColor];
    }
}

- (void)createSubviews {
    
    self.productImageView = [[UIImageView alloc] init];
    self.productImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.productImageView];
    
    self.productNameLabel = [[UILabel alloc] init];
    self.productNameLabel.textColor = [UIColor walmartDarkGrayColor];
    self.productNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.productNameLabel.textAlignment = NSTextAlignmentLeft;
    self.productNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.productNameLabel.numberOfLines = 3;
    self.productNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.productNameLabel];
    
    self.priceView = [[VariableFontSizePriceView alloc] init];
    self.priceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.priceView];
    
    self.starRatingView = [[StarRatingView alloc] init];
    self.starRatingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.starRatingView];

    self.inStockStatusLabel = [[UILabel alloc] init];
    self.inStockStatusLabel.textColor = [UIColor walmartGreenColor];
    self.inStockStatusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.inStockStatusLabel.textAlignment = NSTextAlignmentLeft;
    self.inStockStatusLabel.numberOfLines = 1;
    self.inStockStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.inStockStatusLabel];
}

- (void)createConstraints {
    NSDictionary *viewDict = @{
                               @"productImageView" : self.productImageView,
                               @"productNameLabel" : self.productNameLabel,
                               @"priceView": self.priceView,
                               @"starRatingView": self.starRatingView
                               };
    NSDictionary *metricsDict = @{
                                  @"productImageViewWidth" : @(kCellImageWidth)
                                  };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[productImageView(==productImageViewWidth)]-10-[productNameLabel]" options:0 metrics:metricsDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[priceView]-|" options:0 metrics:nil views:viewDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.productImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:kCellImageWidth]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.productImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[productNameLabel]" options:0 metrics:nil views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[priceView]" options:0 metrics:nil views:viewDict]];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.starRatingView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.productNameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.starRatingView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.productNameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:6.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inStockStatusLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.productNameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.inStockStatusLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.starRatingView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:6.0]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    CGFloat availableLabelWidth = self.priceView.frame.origin.x - 10 - self.productNameLabel.frame.origin.x;
    self.productNameLabel.preferredMaxLayoutWidth = availableLabelWidth;
    
    [super layoutSubviews];
}

@end