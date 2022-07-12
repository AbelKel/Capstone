//
//  MatchViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/10/22.
//
#import "MatchViewController.h"
#import "APIManager.h"
#import "College.h"
#import "AccountViewController.h"

@interface MatchViewController ()
@property (weak, nonatomic) IBOutlet UISlider *satSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeProperty;
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSize;
@property (weak, nonatomic) IBOutlet UILabel *satLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) NSString *collegePropertyString;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) NSString *collegeSizeString;
@property (weak, nonatomic) NSString *zipcode;
@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) NSString *satScore;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSMutableArray *initailCollegeList;
@end

@implementation MatchViewController
    

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredList = [[NSMutableArray alloc] init];
    self.initailCollegeList = [[NSMutableArray alloc] init];
}

- (void)fetchData {
    [[APIManager shared] fetchCollegesForFiltering:^(NSArray *colleges, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self.initailCollegeList = (NSMutableArray *)colleges;
            NSLog(@"%@", self.initailCollegeList);
            for (College *college in self.initailCollegeList) {
                NSLog(@"%@", college.name);
            }
        }
    }];
}

- (IBAction)didSlideScore:(id)sender {
    self.satLabel.text = [NSString stringWithFormat:@"%0.0f", self.satSlider.value];
    self.satScore = self.satLabel.text;
}

- (IBAction)segmentCollegeProperty:(id)sender { 
    switch (self.collegeProperty.selectedSegmentIndex) {
        case 0:
            [[APIManager shared] chosePublic];
            break;
        case 1:
            [[APIManager shared] chosePrivate];
            break;
    }
}

- (IBAction)segemntedControlCity:(id)sender {
    switch (self.collegeSize.selectedSegmentIndex) {
        case 0:
            [[APIManager shared] choseSmall];
            break;
        case 1:
            [[APIManager shared] choseLarge];
            break;
    }
}

- (IBAction)didTapAddZipcode:(id)sender {
    self.zipcode = self.zipcodeField.text;
}

- (IBAction)didTapAddCity:(id)sender {
    self.city = self.cityField.text;
}

- (IBAction)filterButton:(id)sender {
    [self fetchData];
}

// parameters to consider (college.location == self.city) &&
// college.distance < 1000
// ((college.rigorScore*100) < [self.satScore doubleValue])
- (void)filter {
    for (College *college in self.initailCollegeList) {
        if ((college.rigorScore*1000) > [self.satScore doubleValue]) {
            [self.filteredList addObject:college];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self filter];
    AccountViewController *accountVC = [segue destinationViewController];
    accountVC.matchedColleges = self.filteredList;
}
@end
