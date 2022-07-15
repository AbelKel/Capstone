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
@property (nonatomic) double min;
@property (weak, nonatomic) NSString *cWord;
@end

@implementation HomeViewController {
    bool isFiltered;
    NSMutableArray *filteredColleges;
    NSMutableArray *colleges;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    isFiltered = false;
    self->colleges = [[NSMutableArray alloc] init];
    [[AutocorrectFunctions shared] createCoordinates];
    [self fetchData];
}
- (void)fetchData {
    [[APIManager shared] fetchColleges:^(NSArray *colleges, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self->colleges = (NSMutableArray *)colleges;
            [self.tableView reloadData];
        }
    }];
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
    }
    [self.tableView reloadData];
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
    [cell buildCell];
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
