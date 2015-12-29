//
//  ActivityIndicatorWithBezel.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/27/15.
//
//

#import "ActivityIndicatorWithBezel.h"

@interface ActivityIndicatorWithBezel () {
    UIView *_contentView;
}
@end

@implementation ActivityIndicatorWithBezel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSubViews];
        [self createConstraints];
    }
    
    return self;
}

- (void)createSubViews {
    
    self.layer.cornerRadius = 10;
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activitySpinner.translatesAutoresizingMaskIntoConstraints = NO;    
    [_contentView addSubview:self.activitySpinner];
    
    self.activityMessageLabel = [[UILabel alloc] init];
    self.activityMessageLabel.text = @"Loading...";
    self.activityMessageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    self.activityMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.activityMessageLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    self.activityMessageLabel.backgroundColor = [UIColor clearColor];
    self.activityMessageLabel.numberOfLines = 1;
    self.activityMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:self.activityMessageLabel];
    
    [self addSubview:_contentView];
}

- (void)createConstraints {
    
    NSDictionary *viewDict = @{
                               @"activitySpinner" : self.activitySpinner,
                               @"activityMessageLabel" : self.activityMessageLabel
                               };
    
    // Fixed height and width
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:100.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:113.5]];
    
    // Alignment of spinner and label to each other and to contentView wrapper
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[activitySpinner]-4-[activityMessageLabel]|" options:0 metrics:nil views:viewDict]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.activityMessageLabel
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.activitySpinner
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[activityMessageLabel]|" options:0 metrics:nil views:viewDict]];
    
    
    // Center grouping of spinner and label within bezel region
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0]];    
}

- (void)activate {
    self.isActive = YES;
    [self.activitySpinner startAnimating];
    [self setHidden:NO];
}

- (void)dismiss {
    self.isActive = NO;
    [self.activitySpinner stopAnimating];
    [self setHidden:YES];
}

@end