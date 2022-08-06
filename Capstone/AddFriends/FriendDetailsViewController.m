//
//  FriendDetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import <Parse/Parse.h>
#import "ParseCollege.h"
#import "Parse/PFImageView.h"
#import "FriendDetailsViewController.h"
#import "FriendMatchesCell.h"
#import "DetailsViewController.h"
 
@interface FriendDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendFriendRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelFriendRequestButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
 
@implementation FriendDetailsViewController {
    NSArray<ParseCollege *> *usersMatchedColleges;
    NSMutableArray<NSString *> *friends;
    NSMutableArray<NSString *> *localFriends;
    PFRelation *matchesRelation;
    PFUser *currentUser;
}
 
- (void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.usernameLabel.text = self.user.username;
    self->currentUser = [PFUser currentUser];
    self->localFriends = currentUser[@"friends"];
    [self requestStatusChecker:nil];
    [self getUserImage];
    [self getUsersMatches];
}
 
- (void)getUserImage {
    PFFileObject *userProfileImage = self.user[@"image"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [userProfileImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.userImage.image = image;
            }
        }];
    });
}
 
- (void)getUsersMatches {
    self->matchesRelation = [self.user relationForKey:@"matches"];
    PFQuery *query = [matchesRelation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self->usersMatchedColleges = colleges;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
 
- (IBAction)didTapSendFriendRequest:(id)sender {
    [self requestStatusChecker:true];
    [self->localFriends addObject:self.user.objectId];
    self->currentUser[@"friends"] = [NSMutableArray arrayWithArray:self->localFriends];
    [self->currentUser saveInBackground];
}
 
- (IBAction)didTapCancelRequest:(id)sender {
    [self requestStatusChecker:false];
    if (self->localFriends != nil) {
        [self->localFriends removeObject:self.user.objectId];
        self->currentUser[@"friends"] = [NSMutableArray arrayWithArray:self->localFriends];
        [self->currentUser saveInBackground];
    }
}
 
- (void)requestStatusChecker:(BOOL)changeStatus {
    if (changeStatus) {
        self.sendFriendRequestButton.hidden = YES;
        self.cancelFriendRequestButton.hidden = NO;
        self.friendsButton.hidden = NO;
        self.tableView.hidden = NO;
    } else if (!changeStatus){
        self.friendsButton.hidden = YES;
        self.sendFriendRequestButton.hidden = NO;
        self.cancelFriendRequestButton.hidden = YES;
        self.tableView.hidden = YES;
    } else {
    self.friendsButton.hidden = YES;
    self.tableView.hidden = YES;
    self->friends = self->currentUser[@"friends"];
        if (self->friends != nil) {
            if ([self->friends containsObject:self.user.objectId]) {
                self.friendsButton.hidden = NO;
                self.tableView.hidden = NO;
                self.sendFriendRequestButton.hidden = YES;
                self.cancelFriendRequestButton.hidden = NO;
            } else {
                self.sendFriendRequestButton.hidden = NO;
                self.cancelFriendRequestButton.hidden = YES;
                self.tableView.hidden = YES;
            }
        } else {
            self.sendFriendRequestButton.hidden = NO;
            self.cancelFriendRequestButton.hidden = YES;
        }
    }
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->usersMatchedColleges.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendMatchesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendMatchesCell"];
    ParseCollege *college = self->usersMatchedColleges[indexPath.row];
    cell.college = college;
    return cell;
}
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    ParseCollege *collegeToPass = self->usersMatchedColleges[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.college = collegeToPass;
}
@end
