//
//  ViewController.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/15/15.
//
//

#import "MasterViewController.h"
#import "ProductListTableViewCell.h"
#import "DetailViewController.h"
#import "UIColor+ColorExtensions.h"
#import "Product.h"
#import "ProductDataManager.h"
#import "WalmartAPIManager.h"
#import "ActivityIndicatorWithBezel.h"

@interface MasterViewController () {
    BOOL _UIcreated;
    ActivityIndicatorWithBezel *_loadingDataModalView;
}
@end

@implementation MasterViewController

- (instancetype)init {
    self = [super init];
    if (self)
    {
        self.title = @"";
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor walmartMediumBlueColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [[UINavigationBar appearance] setTranslucent:NO];
        
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavBarLogo.png"]];
        self.numberOfRowsInTableView = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTableWithNewProducts:)
                                                     name:kNewProductsLoadedNotification
                                                   object:[ProductDataManager sharedInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newProductImageAvailable:)
                                                     name:kProductImageLoadedNotification
                                                   object:[ProductDataManager sharedInstance]];
        
        // Error messages
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedErrorMessage:)
                                                     name:kBadHttpStatusError
                                                   object:[ProductDataManager sharedInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedErrorMessage:)
                                                     name:kJsonParsingError
                                                   object:[ProductDataManager sharedInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedErrorMessage:)
                                                     name:kApiCallFailedError
                                                   object:[ProductDataManager sharedInstance]];
    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [[ProductDataManager sharedInstance] getMoreProductsFromStartingIndex:0];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    if (!_UIcreated) {
        _UIcreated = YES;
        
        self.productListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.productListTableView setDelegate:self];
        [self.productListTableView setDataSource:self];
        [self.productListTableView setBounces:YES];
        [self.productListTableView setAllowsSelection:YES];
        [self.productListTableView setScrollEnabled:YES];
        [self.productListTableView setRowHeight:kProductListTableRowHeight];
        [self setView:self.productListTableView];
        
        _loadingDataModalView = [[ActivityIndicatorWithBezel alloc] init];
        [_loadingDataModalView activate];
        [self.view addSubview:_loadingDataModalView];
        
        [self createConstraints];
    }
}

- (void)createConstraints {
    
    // Center bezel activity indicator view in superview
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingDataModalView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingDataModalView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
}

- (void)didReceiveProductImage:(NSUInteger)productIndex {
    NSArray *visiblePaths = [self.productListTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
        if (indexPath.row == productIndex) {
            ProductListTableViewCell *visibleCell = [self.productListTableView cellForRowAtIndexPath:indexPath];
            visibleCell.productImageView.image = [[[[ProductDataManager sharedInstance] products] objectAtIndex:indexPath.row] productImage];
        }
    }
}

- (void)updateTableWithNewProducts:(NSNotification *)notification {
    self.numberOfRowsInTableView = [[[ProductDataManager sharedInstance] products] count];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.productListTableView reloadData];
    });
}

- (void)newProductImageAvailable:(NSNotification *)notification {
    
    if (!_loadingDataModalView.isHidden) {
        [_loadingDataModalView dismiss];
    }
    
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        
        NSUInteger productIndex = [[theData objectForKey:kProductIndexKey] unsignedIntegerValue];
        
        NSArray *visiblePaths = [self.productListTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            if (indexPath.row == productIndex) {
                ProductListTableViewCell *visibleCell = [self.productListTableView cellForRowAtIndexPath:indexPath];
                visibleCell.productImageView.image = [[[[ProductDataManager sharedInstance] products] objectAtIndex:indexPath.row] productImage];
            }
        }
    }
}

- (void)receivedErrorMessage:(NSNotification *)notification {
    if (_loadingDataModalView.isActive) {
        [_loadingDataModalView dismiss];
    }
    NSString *errorMessage;
    NSDictionary *theData = [notification userInfo];
    if ([notification.name isEqualToString:kBadHttpStatusError]) {
        if (theData != nil) {
            NSUInteger httpStatus = [[theData objectForKey:kHttpStatusKey] unsignedIntegerValue];
            errorMessage = [NSString stringWithFormat:@"Received non-OK HTTP status: %lu", httpStatus];
        }
    }
    else {
        NSError *error = [theData objectForKey:kErrorDataKey];
        if ([notification.name isEqualToString:kJsonParsingError]) {
            errorMessage = [NSString stringWithFormat:@"JSON parsing failed with the following error message: %@", [error localizedDescription]];
        }
        else if ([notification.name isEqualToString:kApiCallFailedError]) {
            errorMessage = [NSString stringWithFormat:@"API call failed with the following error message: %@", [error localizedDescription]];
        }
        else {
            errorMessage = [NSString stringWithFormat:@"Received unknown error message."];
        }
    }
    
    // Create alert for error
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:errorMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate methods

static NSString * const CELL_IDENTIFIER = @"ProductListTableViewCellIdentifier";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRowsInTableView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER ];
    }
    
    Product *product = [[[ProductDataManager sharedInstance] products] objectAtIndex:indexPath.row];
    if (product.productImage != nil) {
        cell.productImageView.image = product.productImage;
    }
    cell.productNameLabel.text = product.productName;
    cell.priceView.currencyString = product.currencyString;
    cell.priceView.price = product.price;
    cell.starRatingView.reviewRating = product.reviewRating;
    cell.starRatingView.reviewCount = product.reviewCount;
    cell.inStock = product.inStock;
    
    if ([[ProductDataManager sharedInstance] allProductsLoaded] == NO) {
        if (indexPath.row == [[[ProductDataManager sharedInstance] products] count] - 1) {
            [[ProductDataManager sharedInstance] getMoreProductsFromStartingIndex:indexPath.row + 1];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithProductIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kProductListTableRowHeight;
}

@end