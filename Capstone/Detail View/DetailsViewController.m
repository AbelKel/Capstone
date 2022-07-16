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
    NSMutableDictionary *comments;
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
    PFUser *current = [PFUser currentUser];
    self->likesArray = [NSMutableArray arrayWithArray:current[@"likes"]];
    self->comments = [NSMutableDictionary dictionaryWithDictionary:current[@"comments"]];
    [self likeChecker];
}

- (IBAction)didTapOnGoToWebsite:(id)sender {
    NSString *https = @"https://";
    NSString *urlString = [https stringByAppendingString:self.college.website];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
       [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)didTapLike:(id)sender {
    PFUser *current = [PFUser currentUser];
    if ([self->likesArray containsObject:self.college.name]) {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon.png"]forState:UIControlStateNormal];
        [self->likesArray removeObject:self.college.name];
    } else {
        [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon-red.png"]forState:UIControlStateNormal];
        [self->likesArray addObject: self.college.name];
        PFObject *college = [PFObject objectWithClassName:@"College"];
        college[@"name"] = self.college.name;
        college[@"city"] = self.college.location;
        college[@"shortDescription"] = self.college.details;
        college[@"campusImage"] = self.college.image;
        college[@"website"] = self.college.website;
        [college saveEventually];
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

- (IBAction)didTapComment:(id)sender {
    [self->comments setValue:[NSString stringWithString:self.commentTextField.text] forKey:self.college.name];
    PFUser *current = [PFUser currentUser];
    current[@"comments"] = [NSMutableDictionary dictionaryWithDictionary:self->comments];
    [PFUser.currentUser saveInBackground];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.comment.text = [self->comments objectForKey:self.college.name];
    return cell;
}
@end


