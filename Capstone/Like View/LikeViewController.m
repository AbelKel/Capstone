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

@interface LikeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LikeViewController {
    NSArray *likedCollegeNames;
    NSArray<College *> *colleges;
    NSMutableArray *likedCollegesToDisplay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self->likedCollegeNames = [[NSArray alloc] init];
    self->likedCollegesToDisplay = [[NSMutableArray alloc] init];
    self->colleges = [[NSArray alloc] init];
    PFUser *current = [PFUser currentUser];
    self->likedCollegeNames = current[@"likes"];
    [self fetchLikedCollegeList];
    [self.tableView reloadData];
}

- (void)fetchLikedCollegeList {
    [[APIManager shared] fetchColleges:^(NSArray *colleges, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self->colleges = colleges;
            [self findLikedCollegeObjects];
        }
    }];
}

- (void)findLikedCollegeObjects {
    for (College *college in self->colleges) {
        if ([likedCollegeNames containsObject:college.name]) {
            [self->likedCollegesToDisplay addObject: college];
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->likedCollegesToDisplay.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCell"];
    College *college = self->likedCollegesToDisplay[indexPath.row];
    cell.college = college;
    [cell buildLikeCell];
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
