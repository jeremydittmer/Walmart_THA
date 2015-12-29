//
//  DetailViewController.m
//  Walmart_THA
//
//  Created by Jeremy Dittmer on 12/15/15.
//
//

#import "DetailViewController.h"
#import "ProductDataManager.h"
#import "MainDetailViewCell.h"
#import "HTMLContentCell.h"


@interface DetailViewController () {
    BOOL _UIcreated;
    NSMutableArray *_productDetailTableViewCells;
}
@end

@implementation DetailViewController

- (instancetype)initWithProductIndex:(NSUInteger)productIndex {
    self = [super init];
    if (self)
    {
        // Navigation bar title
        self.title = @"Item Detail";
        
        self.thisProduct = [[[ProductDataManager sharedInstance] products] objectAtIndex:productIndex];
        
        _productDetailTableViewCells = [[NSMutableArray alloc] init];
        if (self.thisProduct.productName != nil) {
            MainDetailViewCell *cell = [[MainDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.productNameLabel.text = self.thisProduct.productName;
            cell.starRatingView.reviewRating = self.thisProduct.reviewRating;
            cell.starRatingView.reviewCount = self.thisProduct.reviewCount;
            cell.productImageView.image = self.thisProduct.productImage;
            cell.priceView.currencyString = self.thisProduct.currencyString;
            cell.priceView.price = self.thisProduct.price;
            [_productDetailTableViewCells addObject:cell];
        }
        if (self.thisProduct.shortDescription != nil) {
            HTMLContentCell *cell = [[HTMLContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.sectionTitle.text = @"Details";
            cell.htmlContent.attributedText = [HTMLContentCell attributedHTMLStringFromNSString:self.thisProduct.shortDescription];
            [_productDetailTableViewCells addObject:cell];
        }
        if (self.thisProduct.longDescription != nil) {
            HTMLContentCell *cell = [[HTMLContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.sectionTitle.text = @"Item Description";
            cell.htmlContent.attributedText = [HTMLContentCell attributedHTMLStringFromNSString:self.thisProduct.longDescription];
            [_productDetailTableViewCells addObject:cell];
        }
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!_UIcreated) {
        _UIcreated = YES;
        self.productDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.productDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.productDetailTableView setDelegate:self];
        [self.productDetailTableView setDataSource:self];
        [self.productDetailTableView setBounces:YES];
        [self.productDetailTableView setAllowsSelection:NO];
        [self.productDetailTableView setScrollEnabled:YES];
        [self.productDetailTableView setEstimatedRowHeight:300];
        [self.productDetailTableView setRowHeight:UITableViewAutomaticDimension];
        [self.view addSubview:self.productDetailTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_productDetailTableViewCells count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_productDetailTableViewCells objectAtIndex:indexPath.row];
}

@end