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
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *sendFriendRequest;
@property (weak, nonatomic) IBOutlet UIButton *cancelFriendRequest;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *friends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FriendDetailsViewController {
    NSArray *usersMatchedColleges;
    NSMutableArray *friends;
    NSMutableArray *localFriends;
    PFRelation *matchesRelation;
    PFUser *currentUser;
}

- (void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.username.text = self.user.username;
    self->localFriends = [[NSMutableArray alloc] init];
    self->currentUser = [PFUser currentUser];
    self->localFriends = currentUser[@"friends"];
    self.friends.hidden = YES;
    self.tableView.hidden = YES;
    [self requestStatusChecker];
    [self getUserImage];
    [self getUsersMatches];
}

- (void)getUserImage {
    PFFileObject *userProfileImage = self.user[@"image"];
    [userProfileImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.userImage.image = image;
        }
    }];
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
    self.sendFriendRequest.hidden = YES;
    self.cancelFriendRequest.hidden = NO;
    self.friends.hidden = NO;
    self.tableView.hidden = NO;
    [self->localFriends addObject:self.user.objectId];
    self->currentUser[@"friends"] = [NSMutableArray arrayWithArray:self->localFriends];
    [self->currentUser saveInBackground];
}

- (IBAction)didTapCancelRequest:(id)sender {
    self.friends.hidden = YES;
    self.sendFriendRequest.hidden = NO;
    self.cancelFriendRequest.hidden = YES;
    self.tableView.hidden = YES;
    if (self->localFriends != nil) {
        [self->localFriends removeObject:self.user.objectId];
        self->currentUser[@"friends"] = [NSMutableArray arrayWithArray:self->localFriends];
        [self->currentUser saveInBackground];
    }
}

- (void)requestStatusChecker {
    self->friends = self->currentUser[@"friends"];
    if (self->friends != nil) {
        if ([self->friends containsObject:self.user.objectId]) {
            self.friends.hidden = NO;
            self.tableView.hidden = NO;
            self.sendFriendRequest.hidden = YES;
            self.cancelFriendRequest.hidden = NO;
        } else {
            self.sendFriendRequest.hidden = NO;
            self.cancelFriendRequest.hidden = YES;
            self.tableView.hidden = YES;
        }
    } else {
        self.sendFriendRequest.hidden = NO;
        self.cancelFriendRequest.hidden = YES;
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
