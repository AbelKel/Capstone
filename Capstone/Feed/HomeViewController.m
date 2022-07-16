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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) UITableView *autocompleteTableView;
@end

@implementation HomeViewController {
    bool isFiltered;
    NSMutableArray *filteredColleges;
    NSMutableArray *colleges;
    NSString *correctWordToDisplayInSearchBar;
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
    [[APIManager shared] fetchColleges:^(NSArray *colleges, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self->colleges = (NSMutableArray *)colleges;
            [self.activityIndicator stopAnimating];
            [self.activityIndicator hidesWhenStopped];
            [self.tableView reloadData];
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.autocompleteTableView = [[UITableView alloc] initWithFrame: // still working on the tableview for autocomplete
        CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = NO;
    [self.view addSubview:self.autocompleteTableView];
    [self.autocompleteTableView reloadData];
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
        NSString *correctWord = [[AutocorrectFunctions shared] findCorrectWord:searchText:self->colleges];
        self->correctWordToDisplayInSearchBar = correctWord;
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = self->correctWordToDisplayInSearchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return self->filteredColleges.count;
    }
    return self->colleges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
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
