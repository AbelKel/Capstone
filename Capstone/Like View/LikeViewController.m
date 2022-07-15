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
@property (strong, nonatomic) NSMutableArray *posts;
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
    [self getPosts];
    [self.tableView reloadData];

}

- (void)getPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"College"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            self->colleges = [College collegesWithArray:self.posts];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->colleges.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCell"];
    College *college = self->colleges[indexPath.row];
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
