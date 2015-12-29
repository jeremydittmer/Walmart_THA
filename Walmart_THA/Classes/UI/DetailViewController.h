//
//  DetailViewController.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/15/15.
//
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *productDetailTableView;
@property (nonatomic, strong) Product *thisProduct;

- (instancetype)initWithProductIndex:(NSUInteger)productIndex;

@end