//
//  VariableFontSizePriceView.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import "VariableFontSizePriceView.h"

#import "UIColor+ColorExtensions.h"


@interface VariableFontSizePriceView () {
    UILabel *priceCurrencySymbolLabel;
    UILabel *priceIntegerPortionLabel;
    UILabel *priceFractionalPortionLabel;
}
@end


@implementation VariableFontSizePriceView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        priceCurrencySymbolLabel = [[UILabel alloc] init];
        priceCurrencySymbolLabel.textColor = [UIColor walmartOrangeColor];
        priceCurrencySymbolLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        priceCurrencySymbolLabel.textAlignment = NSTextAlignmentRight;
        priceCurrencySymbolLabel.numberOfLines = 1;
        priceCurrencySymbolLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:priceCurrencySymbolLabel];
        
        priceIntegerPortionLabel = [[UILabel alloc] init];
        priceIntegerPortionLabel.textColor = [UIColor walmartOrangeColor];
        priceIntegerPortionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:26];
        priceIntegerPortionLabel.textAlignment = NSTextAlignmentRight;
        priceIntegerPortionLabel.numberOfLines = 1;
        priceIntegerPortionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:priceIntegerPortionLabel];
        
        priceFractionalPortionLabel = [[UILabel alloc] init];
        priceFractionalPortionLabel.textColor = [UIColor walmartOrangeColor];
        priceFractionalPortionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        priceFractionalPortionLabel.textAlignment = NSTextAlignmentLeft;
        priceFractionalPortionLabel.numberOfLines = 1;
        priceFractionalPortionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:priceFractionalPortionLabel];
        
        // Defaults; these must be called after UILabels have been initialized since they populate the UILabel.text fields
        self.currencyString = @"$";
        self.price = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        
        [self createConstraints];
    }
    return self;
}

// Override setter for currencyString so that the UILabel text will be changed
- (void)setCurrencyString:(NSString *)currencyString {
    if (![_currencyString isEqualToString:currencyString]) {

        // - For now, we just display the currency string in front of the value (this would work for dollars, pounds, euros, etc.).  In the future, this could be used as a trigger for localization of the price value to be displayed.
        _currencyString = currencyString;
        priceCurrencySymbolLabel.text = _currencyString;
    }
}

// Override setter for price so that the NSDecimalNumber will be properly processed and propagated to the UILabels when the value of price is changed
- (void)setPrice:(NSDecimalNumber *)price {
    if (![_price isEqualToNumber:price]) {
        
        // - Integer and fractional portions are split apart to match styling of existing Walmart iPhone app.  Thus, no separator (period in U.S., comma in Europe) is required.
        // - No thousands separator is used (again, to match current iPhone app); also, most products at Walmart cost less than $1000 so this is generally a non-issue
        _price = price;
        NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *integerPortionOfPrice = [_price decimalNumberByRoundingAccordingToBehavior:behavior];
        NSDecimalNumber *fractionalPortionOfPrice = [[_price decimalNumberBySubtracting:integerPortionOfPrice] decimalNumberByMultiplyingByPowerOf10:2];
        priceIntegerPortionLabel.text = [NSString stringWithFormat:@"%d", [integerPortionOfPrice intValue]];
        priceFractionalPortionLabel.text = [NSString stringWithFormat:@"%02d", [fractionalPortionOfPrice intValue]];
    }
}

- (void)createConstraints {
    NSDictionary *viewDict = @{
                               @"priceCurrencySymbolLabel" : priceCurrencySymbolLabel,
                               @"priceIntegerPortionLabel" : priceIntegerPortionLabel,
                               @"priceFractionalPortionLabel" : priceFractionalPortionLabel
                               };

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[priceCurrencySymbolLabel]-0-[priceIntegerPortionLabel]-0-[priceFractionalPortionLabel]|" options:0 metrics:nil views:viewDict]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[priceIntegerPortionLabel]|" options:0 metrics:nil views:viewDict]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:priceIntegerPortionLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:priceFractionalPortionLabel
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:-4.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:priceCurrencySymbolLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:priceFractionalPortionLabel
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
}

@end
