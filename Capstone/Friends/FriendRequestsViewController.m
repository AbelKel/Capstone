//
//  FriendRequestsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//

#import "FriendRequestsViewController.h"
#import "FriendRequestsViewCell.h"
#import "FriendDetailsViewController.h"
#import "ParseCollege.h"
#import <Parse/Parse.h>

@interface FriendRequestsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FriendRequestsViewController{
    NSMutableArray<PFUser *> *usersFromParse;
    NSMutableArray<PFUser *> *suggestedUsers;
    NSMutableArray<ParseCollege *> *userLikedColleges;
    PFUser *loggedInUser;
    int allUsersFromParseIndex;
}

- (void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self->suggestedUsers = [[NSMutableArray alloc] init];
    self->loggedInUser = [PFUser currentUser];
    [self fetchAllUsers];
    [self.activityIndicator startAnimating];
}

- (void)fetchAllUsers {
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        if (users != nil) {
            self->usersFromParse = users;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self getCurrentUserLikes];
}

- (void)getCurrentUserLikes {
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"likes"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self->userLikedColleges = colleges;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self suggestions];
}

- (void)suggestions {
    allUsersFromParseIndex = 0;
    double constantDelay = 0.5;
    [NSTimer scheduledTimerWithTimeInterval:constantDelay target:self selector:@selector(getPreferredUsers:) userInfo:nil repeats:YES];
}

- (void)getPreferredUsers:(NSTimer *)timer {
    if (allUsersFromParseIndex < self->usersFromParse.count) {
        PFUser *currentUser = [self->usersFromParse objectAtIndex:allUsersFromParseIndex];
        PFRelation *relation = [currentUser relationForKey:@"likes"];
        PFQuery *query = [relation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
            NSMutableArray *myColleges = [[NSMutableArray alloc] init];
            for (ParseCollege *college in colleges) {
                [myColleges addObject:college.name];
            }
            for (ParseCollege *college in self->userLikedColleges) {
                if ([myColleges containsObject:college.name] && self->loggedInUser.username != currentUser.username) {
                    [self->suggestedUsers addObject:currentUser];
                }
            }
        }];
        self->allUsersFromParseIndex++;
    } else {
        [timer invalidate];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator hidesWhenStopped];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->suggestedUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendRequestsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    PFUser *user = self->suggestedUsers[indexPath.row];
    cell.user = user;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    PFUser *userToPass = self->suggestedUsers[myIndexPath.row];
    FriendDetailsViewController *friendVC = [segue destinationViewController];
    friendVC.user = userToPass;
}
@end
