//
//  HomeViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/4/22.
//
#import "HomeViewController.h"
#import "HomeCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "APIManager.h"
#import "College.h"
#import "AutocorrectFunctions.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlHome;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation HomeViewController {
    bool isFiltered;
    NSMutableArray<College *> *filteredColleges;
    NSArray<College *> *collegesAtSegment;
    NSString *correctWordToDisplayInSearchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    isFiltered = false;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCollegesForSegmentControl) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self getCollegesForSegmentControl];
    [self.activityIndicator startAnimating];
}

- (IBAction)segmentControl:(id)sender {
    [self getCollegesForSegmentControl];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isFiltered = false;
    } else {
        isFiltered = true;
        self->filteredColleges = [[NSMutableArray alloc] init];
        for (College *college in self->collegesAtSegment) {
            NSRange collegeName = [college.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (collegeName.location != NSNotFound) {
                [self->filteredColleges addObject:college];
            } else if ([college.details rangeOfString:searchText].location != NSNotFound) {
                [self->filteredColleges addObject:college];
            }
        }
        NSString *correctWord = [AutocorrectFunctions findCorrectWord:searchText forCollegesInArray:self->collegesAtSegment];
        self->correctWordToDisplayInSearchBar = correctWord;
    }
    [self.tableView reloadData];
}

- (IBAction)didTapRigor:(id)sender {
    NSSortDescriptor *sortingBasedOnRigor = [[NSSortDescriptor alloc] initWithKey:@"rigorScore" ascending:YES];
    self->collegesAtSegment = [self->collegesAtSegment sortedArrayUsingDescriptors:@[sortingBasedOnRigor]];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = self->correctWordToDisplayInSearchBar;
}

- (void)getCollegesForSegmentControl {
    int segmentIndexCorrection = 10;
    int getCollegesFromAPIAtPostion = self.segmentControlHome.selectedSegmentIndex*10 + segmentIndexCorrection;
    NSString *segmentPosition = [NSString stringWithFormat:@"%d", (getCollegesFromAPIAtPostion)];
    [[APIManager shared] fetchCollegeForSegment:segmentPosition getColleges:^(NSArray * _Nonnull colleges, NSError * _Nonnull error) {
        if (error == nil) {
            self->collegesAtSegment = colleges;
            NSSortDescriptor *sortingBasedOnRigor = [[NSSortDescriptor alloc] initWithKey:@"rigorScore" ascending:YES];
            self->collegesAtSegment = [self->collegesAtSegment sortedArrayUsingDescriptors:@[sortingBasedOnRigor]];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator hidesWhenStopped];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didTapLoadWithLocation:(id)sender {
    NSSortDescriptor *sortingBasedOnDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    self->collegesAtSegment = [self->collegesAtSegment sortedArrayUsingDescriptors:@[sortingBasedOnDistance]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return self->filteredColleges.count;
    }
    return self->collegesAtSegment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (isFiltered) {
        College *college = self->filteredColleges[indexPath.row];
        cell.college = college;
    } else {
        College *college = self->collegesAtSegment[indexPath.row];
        cell.college = college;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    College *collegeToPass = self->collegesAtSegment[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.college = collegeToPass;
}
@end
