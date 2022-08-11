//
//  AccountViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//
#import "AccountViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "AFNetworking/AFNetworking.h"
#import <FBSDKCoreKit/FBSDKProfile.h>
#import "MatchCell.h"
#import "MatchViewController.h"
#import "ParseCollege.h"
#import "DetailsViewController.h"
#import "Translate.h"

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource, MatchViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UINavigationItem *profileNavgation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *takeSurveyButton;
@property (weak, nonatomic) IBOutlet UILabel *matchedCollegesLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *highSchoolLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AccountViewController {
    NSMutableArray<ParseCollege *> *collegesFromQuery;
    PFUser *currentUser;
    PFRelation *matchesRelation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self->currentUser = [PFUser currentUser];
    if (self->currentUser == nil) {
        [self loginWithFacebook];
    }
    [self setUser];
    [self setImageBoarderSize];
    self->matchesRelation = [currentUser relationForKey:@"matches"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMatchedColleges) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loginWithFacebook {
    [self setUser];
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if(profile) {
                NSString *lastnameWithSpace = [@" " stringByAppendingString:profile.lastName];
                NSString *fullName = [profile.firstName stringByAppendingString:lastnameWithSpace];
                self.profileName.text = fullName;
                NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(0, 0)];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                self.profileImage.image = image;
            }
        }];
    });
    NSString *facebookLoginAlertTilte = @"Create an account";
    NSString *facebookLoginAlertMessage = @"Please create an account to have access to matching, news, and likes.";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:facebookLoginAlertTilte message:facebookLoginAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [Translate textToTranslate:@"Take the Survey" translatedTextBlock:^(NSString * _Nonnull text) {
        [self.takeSurveyButton setTitle:text forState:UIControlStateNormal];
        if (text == nil) {
            NSString *translationErrorAlertTilte = @"Cannot translate app!";
            NSString *translationErrorAlertMessage = @"We are currently having issues translating the app to your selected language. Please check your internet connection.";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:translationErrorAlertTilte message:translationErrorAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    [Translate textToTranslate:@"Log out" translatedTextBlock:^(NSString * _Nonnull text) {
        [self.logoutButton setTitle:text forState:UIControlStateNormal];
    }];
    [Translate textToTranslate:@"Matched Colleges" translatedTextBlock:^(NSString * _Nonnull text) {
        self.matchedCollegesLabel.text = text;
    }];
    [Translate textToTranslate:@"Profile" translatedTextBlock:^(NSString * _Nonnull text) {
        self.profileNavgation.title = text;
    }];
    if (self->currentUser[@"image"]) {
        self.profileImage.file = self->currentUser[@"image"];
        [self.profileImage loadInBackground];
    }
    [self getMatchedColleges];
}

- (void)getMatchedColleges {
    PFQuery *query = [self->matchesRelation query];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            self.takeSurveyButton.hidden = YES;
            self->collegesFromQuery = colleges;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapLogout:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        self.view.window.rootViewController = loginViewController;
    }];
}

- (void)setUser {
    PFUser *username = [PFUser currentUser];
    self.profileName.text = username.username;
    if (self->currentUser[@"age"] != nil && self->currentUser[@"highSchool"] != nil) {
        self.ageLabel.text = self->currentUser[@"age"];
        self.highSchoolLabel.text = self->currentUser[@"highSchool"];
    } else {
        self.ageLabel.hidden = YES;
        self.highSchoolLabel.hidden = YES;
    }
}

- (void)doneWithMatchingColleges {
    self.takeSurveyButton.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->collegesFromQuery.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    College *college = self->collegesFromQuery[indexPath.row];
    cell.college = college;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"detailSegueForDetailsView"]) {
        if (self->collegesFromQuery != nil) {
            UITableViewCell *cell = sender;
            NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
            College *collegeToPass = self->collegesFromQuery[myIndexPath.row];
            DetailsViewController *detailVC = [segue destinationViewController];
            detailVC.college = collegeToPass;
        }
    } else if ([[segue identifier] isEqualToString:@"surveySegue"]) {
        MatchViewController *matchVC = [segue destinationViewController];
        matchVC.delegate = self;
    }
}

- (void)setImageBoarderSize {
    double radius = 1.995;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/radius;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
}
@end
