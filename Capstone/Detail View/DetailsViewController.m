//
//  DetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TTTAttributedLabel.h"
#import <Parse/Parse.h>
#import "CommentCell.h"
#import "LikeViewController.h"
#import "LongDetailsViewController.h"
#import "Comment.h"
#import "LikesRelations.h"
#import "ParseCollege.h"

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *detailsCollegeImage;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeName;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeDetails;
@property (weak, nonatomic) IBOutlet UIButton *likeCollege;
@property (weak, nonatomic) IBOutlet UITextView *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DetailsViewController {
    NSArray<Comment *> *comments;
    NSMutableArray<LikesRelations *> *likedCollegesFromParse;
    NSMutableArray<ParseCollege *> *colleges;
    NSMutableArray<LikesRelations *> *likedRelations;
    NSMutableArray<ParseCollege *> *allLikedColleges;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self->likedRelations = [[NSMutableArray alloc] init];
    self.detailsCollegeName.text = self.college.name;;
    self.detailsCollegeDetails.text = self.college.details;
    self.detailsCollegeLocation.text = self.college.location;
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.detailsCollegeImage setImageWithURL:url];
    self->colleges = [[NSMutableArray alloc] init];
    self->allLikedColleges = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.detailsCollegeImage setUserInteractionEnabled:YES];
    [self.detailsCollegeImage addGestureRecognizer:tapGesture];
    [self getComments];
    [self getLikedColleges];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"moreDetails" sender:self];
}

- (IBAction)didTapOnGoToWebsite:(id)sender {
    NSString *https = @"https://";
    NSString *urlString = [https stringByAppendingString:self.college.website];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
       [[UIApplication sharedApplication] openURL:url];
    }
}

/*
 This method gets the Parse Objects from Like Relations class in Parse along with all the  collges the
 user has liked hence the key being used "likedCollege"
 */
- (void)getLikedColleges {
    PFQuery *query = [PFQuery queryWithClassName:@"LikesRelations"];
    [query includeKey:@"likedCollege"];
    [query includeKey:@"author"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self->likedCollegesFromParse = (NSMutableArray *)colleges;
            for (LikesRelations *allCollegeObjetsInParse in self->likedCollegesFromParse) {
                [self->allLikedColleges addObject:allCollegeObjetsInParse.likedCollege];
            }
            for (LikesRelations *collegeFromParse in self->likedCollegesFromParse) {
                if (collegeFromParse.author.username == [PFUser currentUser].username) {
                    [self->colleges addObject:collegeFromParse.likedCollege];
                }
            }
            [self likeChecker];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
 Should I implement pointers and relations for this. It seems to work fine without them.
 */
- (void)getComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query includeKey:@"author"];
    [query whereKey:@"college" equalTo:self.college.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self->comments = comments;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
 This works well, but I feel like it can be optimized.
 */

- (IBAction)didTapLike:(id)sender {
    NSMutableArray *likedCollegeNames = [[NSMutableArray alloc] init];
    for (ParseCollege *likedColleges in self->colleges) {
        [likedCollegeNames addObject:likedColleges.name];
    }
    if ([likedCollegeNames containsObject:self.college.name]) {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon.png"]forState:UIControlStateNormal];
        [self deleteParseObject:self.college.name];
    } else {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon-red.png"]forState:UIControlStateNormal];
        NSMutableArray *allLikedCollegeNames = [[NSMutableArray alloc] init];
        for (ParseCollege *likedColleges in self->allLikedColleges) {
            [allLikedCollegeNames addObject:likedColleges.name];
        }
        if (![allLikedCollegeNames containsObject:self.college.name]) {
            ParseCollege *current = [ParseCollege postCollege:self.college withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            }];
            [LikesRelations postUserLikes:self.college forParseCollege:current withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            }];
        } else {
            for (ParseCollege *college in self->allLikedColleges) {
                if ([college.name isEqual:self.college.name]) {
                    [LikesRelations postUserLikes:self.college forParseCollege:college withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                }
            }
        }
    }
}

- (void)deleteParseObject:(NSString *)name {
    PFQuery *query = [PFQuery queryWithClassName:@"LikesRelations"];
    [query includeKey:@"likedCollege"];
    [query includeKey:@"author"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            for (LikesRelations *relation in colleges) {
                ParseCollege *collegeToDelete = relation.likedCollege;
                if ([[PFUser currentUser].username isEqual:relation.username] && ([collegeToDelete.name isEqual:self.college.name])) {
                    [relation deleteInBackground];
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)likeChecker {
    NSMutableArray *likedCollegeNames = [[NSMutableArray alloc] init];
    for (ParseCollege *likedColleges in self->colleges) {
        [likedCollegeNames addObject:likedColleges.name];
    }
    if ([likedCollegeNames containsObject:self.college.name]) {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon-red.png"]forState:UIControlStateNormal];
    } else {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon.png"]forState:UIControlStateNormal];
    }
    
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didTapComment:(id)sender {
    [Comment postUserComment:self.commentTextField.text underCollege:self.college.name withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = self->comments[indexPath.row];
    cell.commentPosted = comment;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    College *collegeToPass = self.college;
    LongDetailsViewController *longDVC = [segue destinationViewController];
    longDVC.college = collegeToPass;
}
@end


