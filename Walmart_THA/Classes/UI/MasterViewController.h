//
//  ViewController.h
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/15/15.
//
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *productListTableView;
@property (nonatomic, assign) NSUInteger numberOfRowsInTableView;

@end

