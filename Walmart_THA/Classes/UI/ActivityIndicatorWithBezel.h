//
//  ActivityIndicatorWithBezel.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/27/15.
//
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorWithBezel : UIView

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) UIActivityIndicatorView *activitySpinner;
@property (nonatomic, strong) UILabel *activityMessageLabel;

- (void)activate;
- (void)dismiss;

@end
