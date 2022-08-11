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
#import "APIManager.h"
#import "College.h"
#import "Translate.h"

@interface FriendRequestsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *suggestedFriendsNavigationBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FriendRequestsViewController {
    NSMutableArray<PFUser *> *usersFromParse;
    NSMutableArray<PFUser *> *suggestedUsers;
    NSMutableArray<ParseCollege *> *userLikedColleges;
    PFUser *loggedInUser;
    int allUsersFromParseIndex;
    int numberOfUsersInParse;
}

- (void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self->suggestedUsers = [[NSMutableArray alloc] init];
    self->loggedInUser = [PFUser currentUser];
    [self fetchAllUsers];
    [self.activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [Translate textToTranslate:@"Suggested Friends" translatedTextBlock:^(NSString * _Nonnull text) {
        self.suggestedFriendsNavigationBar.title = text;
    }];
}

- (void)fetchAllUsers {
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        if (users != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->usersFromParse = users;
                [self.tableView reloadData];
                [self getCurrentUserLikes];
            });
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)getCurrentUserLikes {
    PFUser *currentUser = [PFUser currentUser];
    [[APIManager shared] getLikedColleges:currentUser forColleges:^(NSArray * _Nonnull colleges, NSError * _Nonnull error) {
        if (error == nil) {
            self->userLikedColleges = colleges;
            [self suggestions];
        }
    }];
}

- (void)suggestions {
    allUsersFromParseIndex = 0;
    double constantDelay = 0.1;
    [NSTimer scheduledTimerWithTimeInterval:constantDelay target:self selector:@selector(getPreferredUsers:) userInfo:nil repeats:YES];
}

- (void)getPreferredUsers:(NSTimer *)timer {
    if (allUsersFromParseIndex < self->usersFromParse.count) {
        PFUser *currentUser = [self->usersFromParse objectAtIndex:allUsersFromParseIndex];
        PFRelation *usersLikedRelation = [currentUser relationForKey:@"likes"];
        PFQuery *query = [usersLikedRelation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
            for (ParseCollege *college in self->userLikedColleges) {
                if ([ParseCollege arrayContainsCollege:colleges college:college] && ![self->loggedInUser.objectId isEqual:currentUser.objectId]) {
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
