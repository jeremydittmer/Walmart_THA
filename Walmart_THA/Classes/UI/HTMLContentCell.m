//
//  HTMLContentCell.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/23/15.
//
//

#import "HTMLContentCell.h"
#import "UIColor+ColorExtensions.h"

@implementation HTMLContentCell

+ (NSAttributedString *)attributedHTMLStringFromNSString:(NSString *)inString {
    NSString *source = @"<style>mytext{font-family: 'Helvetica Neue';}</style>\n<mytext>";
    source = [source stringByAppendingString:inString];
    source = [source stringByAppendingString:@"</mytext>"];
    return [[NSAttributedString alloc] initWithData:[source dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                 documentAttributes:nil error:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self createConstraints];
    }
    return self;
}

- (void)createSubviews {
    
    self.sectionTitle = [[UILabel alloc] init];
    self.sectionTitle.textAlignment = NSTextAlignmentLeft;
    self.sectionTitle.numberOfLines = 1;
    self.sectionTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    self.sectionTitle.textColor = [UIColor walmartDarkGrayColor];
    self.sectionTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.sectionTitle];
    
    self.htmlContent = [[UILabel alloc] init];
    self.htmlContent.textAlignment = NSTextAlignmentLeft;
    self.htmlContent.numberOfLines = 0;
    self.htmlContent.textColor = [UIColor walmartDarkGrayColor];
    self.htmlContent.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.htmlContent];
}

- (void)createConstraints {
    
    NSDictionary *viewDict = @{
                               @"sectionTitle" : self.sectionTitle,
                               @"htmlContent" : self.htmlContent
                               };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sectionTitle]" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[htmlContent]-|" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[sectionTitle]-[htmlContent]-|" options:0 metrics:nil views:viewDict]];
}

@end