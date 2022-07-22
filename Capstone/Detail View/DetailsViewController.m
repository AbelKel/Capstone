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
    NSArray *comments;
    NSMutableArray *likesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self->likesArray = [[NSMutableArray alloc] init];
    self.detailsCollegeName.text = self.college.name;;
    self.detailsCollegeDetails.text = self.college.details;
    self.detailsCollegeLocation.text = self.college.location;
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.detailsCollegeImage setImageWithURL:url];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.detailsCollegeImage setUserInteractionEnabled:YES];
    [self.detailsCollegeImage addGestureRecognizer:tapGesture];
    PFUser *current = [PFUser currentUser];
    self->likesArray = [NSMutableArray arrayWithArray:current[@"likes"]];
    [self likeChecker];
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
    PFUser *current = [PFUser currentUser];
    if ([self->likesArray containsObject:self.college.name]) {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon.png"]forState:UIControlStateNormal];
        [self->likesArray removeObject:self.college.name];
    } else {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon-red.png"]forState:UIControlStateNormal];
        [self->likesArray addObject: self.college.name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    }
    current[@"likes"] = [NSArray arrayWithArray:self->likesArray];
    [PFUser.currentUser saveInBackground];
}

- (void)likeChecker {
    if ([self->likesArray containsObject:self.college.name]) {
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


