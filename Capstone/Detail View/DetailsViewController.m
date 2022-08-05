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
#import "Translate.h"
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
    PFUser *currentUser;
    PFRelation *likeRelation;
    bool isCollegeAlreadyInParse;
    NSString *iconName;
    ParseCollege *collegeFromParse;
    NSInteger likedCollegeMatches;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Translate textToTranslate:self.college.name translatedTextBlock:^(NSString * _Nonnull text) {
        self.detailsCollegeName.text = text;
    }];
    [Translate textToTranslate:self.college.details translatedTextBlock:^(NSString * _Nonnull text) {
        self.detailsCollegeDetails.text = text;
    }];
    [Translate textToTranslate:self.college.location translatedTextBlock:^(NSString * _Nonnull text) {
        self.detailsCollegeLocation.text = text;
    }];
    NSLog(@"%@", self.detailsCollegeName.text);
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.detailsCollegeImage setImageWithURL:url];
    self->currentUser = [PFUser currentUser];
    self->likeRelation = [self->currentUser relationForKey:@"likes"];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.detailsCollegeImage setUserInteractionEnabled:YES];
    [self.detailsCollegeImage addGestureRecognizer:tapGesture];
    [self allCollegesFromParse];
    [self getComments];
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

- (void)allCollegesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Colleges"];
    [query whereKey:@"name" equalTo:self.college.name];
    NSInteger collegeMatches = [query countObjects];
    if (collegeMatches > 0) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
            self->collegeFromParse = [colleges objectAtIndex:0];
            self->isCollegeAlreadyInParse = true;
            [self likeChecker];
        }];
    }
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
    if (self->likedCollegeMatches > 0) {
        [self->likeRelation removeObject:self->collegeFromParse];
        [self->currentUser saveInBackground];
        self->iconName = @"favor-icon.png";
    } else if (isCollegeAlreadyInParse && likedCollegeMatches == 0) {
        [self->likeRelation addObject:self->collegeFromParse];
        [self->currentUser saveInBackground];
        self->iconName = @"favor-icon-red.png";
    } else {
        ParseCollege *currentCollege = [ParseCollege postCollege:self.college withCompletion:^(BOOL succeeded, NSError * _Nullable error) {}];
        [currentCollege save];
        [self->likeRelation addObject:currentCollege];
        [self->currentUser saveInBackground];
        self->iconName = @"favor-icon-red.png";
    }
    [self.likeCollege setImage:[UIImage imageNamed:self->iconName]forState:UIControlStateNormal];
}

- (void)likeChecker {
    PFQuery *likesQuery = [self->likeRelation query];
    if (self->collegeFromParse != nil) {
    [likesQuery whereKey:@"name" equalTo:self->collegeFromParse.name];
    self->likedCollegeMatches = [likesQuery countObjects];
    }
    if (self->likedCollegeMatches == 1) {
        self->iconName = @"favor-icon-red.png";
    } else if (self->likedCollegeMatches == 0){
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


