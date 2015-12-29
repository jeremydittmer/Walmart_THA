//
//  VariableFontSizePriceView.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import <UIKit/UIKit.h>

@interface VariableFontSizePriceView : UIView

@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *currencyString;

@end
