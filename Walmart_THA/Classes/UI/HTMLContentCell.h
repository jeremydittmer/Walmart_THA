//
//  HTMLContentCell.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import <UIKit/UIKit.h>

@interface HTMLContentCell : UITableViewCell

@property (nonatomic, strong) UILabel *sectionTitle;
@property (nonatomic, strong) UILabel *htmlContent;

+ (NSAttributedString *)attributedHTMLStringFromNSString:(NSString *)inString;

@end