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
#import "MatchesRelations.h"
#import "DetailsViewController.h"

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AccountViewController {
    NSArray<College *> *colleges;
    NSMutableArray<ParseCollege *> *collegesFromQuery;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setUser];
    PFUser *current = [PFUser currentUser];
    if (current[@"image"]) {
        self.profileImage.file = current[@"image"];
        [self.profileImage loadInBackground];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMatchedColleges) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self getMatchedColleges];
}

- (void)getMatchedColleges {
    self->collegesFromQuery = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"MatchesRelations"];
    [query includeKey:@"author"];
    [query includeKey:@"matchedCollege"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            for (MatchesRelations *match in colleges) {
                if (match.author.username == [PFUser currentUser].username) {
                    [self->collegesFromQuery addObject:match.matchedCollege];
                }
            }
            self->colleges = self->collegesFromQuery;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        self.view.window.rootViewController = loginViewController;
    }];
}

-(void)setUser {
    PFUser *username = [PFUser currentUser];
    self.profileName.text = username.username;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->colleges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    College *college = self->colleges[indexPath.row];
    cell.college = college;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"detailSegueForDetailsView"]) {
        if (self->colleges != nil) {
            UITableViewCell *cell = sender;
            NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
            College *collegeToPass = self->colleges[myIndexPath.row];
            DetailsViewController *detailVC = [segue destinationViewController];
            detailVC.college = collegeToPass;
        }
    }
}
@end
