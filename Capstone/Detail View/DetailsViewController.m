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
    NSMutableArray<ParseCollege *> *allLikedColleges;
    NSMutableArray<ParseCollege *> *allCollegesFromParse;
    NSMutableArray<NSString *> *likedCollegeNames;
    PFUser *currentUser;
    PFRelation *relation;
    bool isCollegeAlreadyInParse;
    NSString *iconName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.detailsCollegeName.text = self.college.name;;
    self.detailsCollegeDetails.text = self.college.details;
    self.detailsCollegeLocation.text = self.college.location;
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.detailsCollegeImage setImageWithURL:url];
    self->currentUser = [PFUser currentUser];
    self->allLikedColleges = [[NSMutableArray alloc] init];
    self->likedCollegeNames = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.detailsCollegeImage setUserInteractionEnabled:YES];
    [self.detailsCollegeImage addGestureRecognizer:tapGesture];
    [self allCollegesFromParse];
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


- (void)getLikedColleges {
    self->relation = [self->currentUser relationForKey:@"likes"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self->allLikedColleges = (NSMutableArray *)colleges;
            for (ParseCollege *likedCollege in self->allLikedColleges) {
                [self->likedCollegeNames addObject:likedCollege.name];
            }
            [self likeChecker];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)allCollegesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Colleges"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self->allCollegesFromParse = (NSMutableArray *)colleges;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

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


- (IBAction)didTapLike:(id)sender {
    if ([self->likedCollegeNames containsObject:self.college.name]) {
        for (ParseCollege *likedCollege in self->allLikedColleges) {
            if ([likedCollege.name isEqual:self.college.name]) {
                [self->relation removeObject:likedCollege];
                [self->currentUser save];
            }
        }
        self->iconName = @"favor-icon.png";
    } else {
        self->isCollegeAlreadyInParse = false;
        for (ParseCollege *college in self->allCollegesFromParse) { //checking if the college is already in the parse database
            if ([college.name isEqual:self.college.name]) {
                self->isCollegeAlreadyInParse = true;
                [self->relation addObject:college]; //adding a relation to the already existing college object in parse
                [self->currentUser saveInBackground];
            }
        }
        if (!isCollegeAlreadyInParse) {
            ParseCollege *currentCollege = [ParseCollege postCollege:self.college withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            }];
            [currentCollege save];
            [self->currentUser save];
            [self->relation addObject:currentCollege];
            [self->currentUser saveInBackground];
        }
        self->iconName = @"favor-icon-red.png";
    }
    [self.likeCollege setImage:[UIImage imageNamed:self->iconName]forState:UIControlStateNormal];
}

- (void)likeChecker {
    if ([self->likedCollegeNames containsObject:self.college.name]) {
        self->iconName = @"favor-icon-red.png";
    } else {
        self->iconName = @"favor-icon.png";
    }
    [self.likeCollege setImage:[UIImage imageNamed:self->iconName]forState:UIControlStateNormal];
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


