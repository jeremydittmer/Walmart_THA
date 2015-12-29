//
//  StarRatingView.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import "StarRatingView.h"

#import "UIColor+ColorExtensions.h"

@interface StarRatingView () {
    UILabel *reviewCountLabel;
    UIImageView *starRatingMaskImageView;
    UIView *starRatingBackgroundRectangle;
    UIView *starRatingForegroundRectangle;
    NSLayoutConstraint *starRatingRightEdgeConstraint;
}
@end

@implementation StarRatingView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        [self createSubviews];
        [self createConstraints];
    }
    return self;
}

- (void)createSubviews {
    starRatingBackgroundRectangle = [[UIView alloc] init];
    starRatingBackgroundRectangle.translatesAutoresizingMaskIntoConstraints = NO;
    starRatingBackgroundRectangle.backgroundColor = [UIColor walmartLightGrayColor];
    [self addSubview:starRatingBackgroundRectangle];
    
    starRatingForegroundRectangle = [[UIView alloc] init];
    starRatingForegroundRectangle.translatesAutoresizingMaskIntoConstraints = NO;
    starRatingForegroundRectangle.backgroundColor = [UIColor walmartMediumBlueColor];
    [self addSubview:starRatingForegroundRectangle];
    
    starRatingMaskImageView = [[UIImageView alloc] init];
    starRatingMaskImageView.image = [UIImage imageNamed:@"StarRatingMask"];
    starRatingMaskImageView.translatesAutoresizingMaskIntoConstraints = NO;
    starRatingMaskImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:starRatingMaskImageView];
    
    reviewCountLabel = [[UILabel alloc] init];
    reviewCountLabel.textColor = [UIColor walmartMediumGrayColor];
    reviewCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    reviewCountLabel.textAlignment = NSTextAlignmentLeft;
    reviewCountLabel.numberOfLines = 1;
    reviewCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:reviewCountLabel];
}

// Override setter for reviewRating to make adjustments to how the stars are displayed
- (void)setReviewRating:(CGFloat)reviewRating {
    _reviewRating = reviewRating;
    [self updateConstraints];
}

// Override setter for reviewCount to change the text in the corresponding UILabel
- (void)setReviewCount:(NSUInteger)reviewCount {
    _reviewCount = reviewCount;
    reviewCountLabel.text = [NSString stringWithFormat:@"(%lu)", reviewCount];
}

- (void)createConstraints {
    NSDictionary *viewDict = @{
                               @"starRatingBackgroundRectangle" : starRatingBackgroundRectangle,
                               @"starRatingMaskImageView" : starRatingMaskImageView
                               };
    
    // Fix size of starRatingMaskImageView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[starRatingMaskImageView(==60)]|" options:0 metrics:nil views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[starRatingMaskImageView(==12)]|" options:0 metrics:nil views:viewDict]];
    
    // Background color rectangle edges constrained to those of starRatingMaskImageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingBackgroundRectangle
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingBackgroundRectangle
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingBackgroundRectangle
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingBackgroundRectangle
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    // Foreground color edges constrained to those of starRatingMaskImageView on top, left, and bottom; retain a reference to the right edge constraint so that this can be adjusted based on the star rating value
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingForegroundRectangle
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingForegroundRectangle
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:starRatingForegroundRectangle
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0.0]];
    starRatingRightEdgeConstraint = [NSLayoutConstraint constraintWithItem:starRatingForegroundRectangle
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:self.reviewRating / 5.0 * starRatingMaskImageView.frame.size.width];
    [self addConstraint:starRatingRightEdgeConstraint];
    
    
    
    
    // Label with reviewCount is positioned right of the stars
    [self addConstraint:[NSLayoutConstraint constraintWithItem:reviewCountLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:4.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:reviewCountLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:starRatingMaskImageView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void) updateConstraints {
    
    // If the reviewRating value is changed, we need to change the constraint of the foreground rectangle accordingly
    starRatingRightEdgeConstraint.constant = [self getWidthForRating];
    [self layoutIfNeeded];

    [super updateConstraints];
}

- (CGFloat) getWidthForRating {
    
    CGFloat truncatedRating = (CGFloat)((NSUInteger)self.reviewRating);
    CGFloat ratingFraction = self.reviewRating - truncatedRating;
    
    CGFloat mappedRating = truncatedRating + [self mapRatingFraction:ratingFraction];
    
    return mappedRating / 5.0 * 60.0;
}

// The easiest way to show a fractional star (e.g. the 2/10 of the fourth star for a 3.2 rating) is to simply set the width of the highlighted region relative to the star width to be equal to the fraction itself.  Returning to the previous example, for 3.2 a rectangular region 0.2 times the star's width could be used for the partially highlighted star.  However, due to the shape of the star, small or large fractions are barely visible - 0.2 highlights only a portion of the star's left point.  A way to overcome this is to highlight by area instead of by width.  In other words, for a rating of 3.2, 2/10 of the area of the final star will be highlighted rather than 2/10 of its width.  Calculating the width that corresponds to a fractional star area involves creating a piecewise function for the area of the star through integration and normalization where each piecewise portion takes on the form of Ax^2 + Bx + C since we are integrating triangles and trapezoids.  This gives area as a function of fractional width.  We then take the inverse of each piecewise portion so that we can calculate fractional width as a function of area.  The piecewise portions of the inverse functions each take on the form of (A + sqrt(2 * B * x + C)) / B where constants A, B, and C are different for each piecewise portion.  These constants were precalculated and are used in the calculations below to map an input fraction to a new fraction that will highlight the width of the star which will shade a fractional portion of the star's surface area equal to the input fraction.  Some sample values for this mapping are:
//
//   fraction | fractional width to highlight
//  ------------------------------------------
//   0.0      | 0.0
//   0.1      | 0.2624519
//   0.2      | 0.331259695
//   0.3      | 0.397635125
//   0.4      | 0.453848562
//   0.5      | 0.5
//   0.6      | 0.546151438
//   0.7      | 0.602364875
//   0.8      | 0.668740305
//   0.9      | 0.7375481
//   1.0      | 1.0
- (CGFloat) mapRatingFraction:(CGFloat)ratingFraction {
    
    // A star with width 1.0 is symmetrical about a vertical line at 0.5.  We take advantage of this symmetry in our calculations recognizing that the area from 0 to x is the same as the area from x to 1.
    BOOL mirrorFlag;
    if (ratingFraction > 0.5) {
        mirrorFlag = YES;
        ratingFraction = 1.0 - ratingFraction;
    }
    
    CGFloat A, B, C;
    if (ratingFraction <= 0.04270510) {
        A = 0;
        B = 2.341640786;
        C = 0;
    }
    else if (ratingFraction <= 0.16458980) {
        A = 1.44721360;
        B = 9.91934955;
        C = -0.64721360;
    }
    else if (ratingFraction <= 0.27639320) {
        A = -2.34164079;
        B = -2.34164079;
        C = 3.38885438;
    }
    else {
        A = 1.44721360;
        B = 7.57770876;
        C = -2.09442719;
    }
    
    CGFloat x = (A + sqrt(2 * B * ratingFraction + C)) / B;
    if (mirrorFlag) {
        x = 1.0 - x;
    }

    return x;
}

@end
