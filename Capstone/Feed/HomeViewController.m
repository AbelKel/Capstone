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
    NSMutableArray<College *> *colleges;
    NSMutableArray<College *> *collegesAtSegment2;
    NSString *correctWordToDisplayInSearchBar;
    int currentSegmentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    isFiltered = false;
    self->colleges = [[NSMutableArray alloc] init];
    [self fetchData];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.activityIndicator startAnimating];
}

- (void)fetchData {
    [[APIManager shared] getColleges:^(NSArray * _Nonnull colleges, NSError * _Nonnull error) {
        if (error == nil) {
            self->colleges = (NSMutableArray *)colleges;
            [self.activityIndicator stopAnimating];
            [self.activityIndicator hidesWhenStopped];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (IBAction)segmentControl:(id)sender {
    currentSegmentIndex = self.segmentControlHome.selectedSegmentIndex;
    [[APIManager shared] fetchCollege:^(NSArray * _Nonnull colleges, NSError * _Nonnull error) {
        if (error == nil) {
            self->collegesAtSegment2 = colleges;
        }
    }];
    [self.tableView reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isFiltered = false;
    } else {
        isFiltered = true;
        self->filteredColleges = [[NSMutableArray alloc] init];
        for (College *college in self->colleges) {
            NSRange collegeName = [college.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (collegeName.location != NSNotFound) {
                [self->filteredColleges addObject:college];
            } else if ([college.details rangeOfString:searchText].location != NSNotFound) {
                [self->filteredColleges addObject:college];
            }
        }
        NSString *correctWord = [AutocorrectFunctions findCorrectWord:searchText forCollegesInArray:self->colleges];
        self->correctWordToDisplayInSearchBar = correctWord;
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = self->correctWordToDisplayInSearchBar;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didTapLoadWithLocation:(id)sender {
    NSSortDescriptor *sortingBasedOnDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    self->colleges = [self->colleges sortedArrayUsingDescriptors:@[sortingBasedOnDistance]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentSegmentIndex == 1) {
        return self->collegesAtSegment2.count;
    }
    if (isFiltered) {
        return self->filteredColleges.count;
    }
    return self->colleges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (currentSegmentIndex == 1) {
        College *college = self->collegesAtSegment2[indexPath.row];
        cell.college = college;
    }
    if (isFiltered) {
        College *college = self->filteredColleges[indexPath.row];
        cell.college = college;
    } else {
        College *college = self->colleges[indexPath.row];
        cell.college = college;
    }
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
