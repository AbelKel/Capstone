//
//  LikeViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//
#import "LikeViewController.h"
#import <Parse/Parse.h>
#import "APIManager.h"
#import "College.h"
#import "LikeCell.h"
#import "DetailsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface LikeViewController () <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *collegesFromQuery;
@end

@implementation LikeViewController {
    NSArray<College *> *likedCollegeNames;
    NSArray<College *> *colleges;
    NSMutableArray<College *> *likedCollegesToDisplay;
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self->likedCollegeNames = [[NSArray alloc] init];
    self->likedCollegesToDisplay = [[NSMutableArray alloc] init];
    self->colleges = [[NSArray alloc] init];
    PFUser *current = [PFUser currentUser];
    self->likedCollegeNames = current[@"likes"];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:@"reloadData" object:nil];
    [self getLikedColleges];
    self->refreshControl = [[UIRefreshControl alloc] init];
    [self->refreshControl addTarget:self action:@selector(getLikedColleges) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self->refreshControl atIndex:0];
    [self.activityIndicator startAnimating];
}

- (void)getLikedColleges {
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"College"];
    [query whereKey:@"userID" equalTo:current.username];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self.collegesFromQuery = (NSMutableArray *)colleges;
            self->colleges = [College collegesWithArray:self.collegesFromQuery];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator hidesWhenStopped];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self->refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"college"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor grayColor];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"This page allows you to keep your liked colleges all in one place.";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->colleges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCell"];
    College *college = self->colleges[indexPath.row];
    cell.college = college;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    College *collegeToPass = self->colleges[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.college = collegeToPass;
}
@end
