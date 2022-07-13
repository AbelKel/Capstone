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
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@end

@implementation MatchViewController {
    NSMutableArray *initailCollegeList;
    NSString *satScore;
    NSMutableArray *filteredList;
    NSString *city;
    NSString *zipcode;
    NSString *collegeSizeString;
    NSString *collegePropertyString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self->filteredList = [[NSMutableArray alloc] init];
    self->initailCollegeList = [[NSMutableArray alloc] init];
}

- (void)fetchData {
    [[APIManager shared] fetchCollegesForFiltering:^(NSArray *colleges, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self->initailCollegeList = (NSMutableArray *)colleges;
        }
    }];
}

- (IBAction)didSlideScore:(id)sender {
    self.satLabel.text = [NSString stringWithFormat:@"%0.0f", self.satSlider.value];
    self->satScore = self.satLabel.text;
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
    self->zipcode = self.zipcodeField.text;
}

- (IBAction)didTapAddCity:(id)sender {
    self->city = self.cityField.text;
}

- (IBAction)filterButton:(id)sender {
    [self fetchData];
}
/**
 The lowest rigor score for a college can go as high as upto 50.
 The highest rigor score is 0.1
 The SAT score to Rigor Score conversion would be 50(1-(x/1600)) +0.1
 - parameters to consider (college.location == self.city) &&
 - college.distance < 1000
*/
- (void)filter {
    double convertedScore = 50*(1-(([self->satScore doubleValue])/1600))+0.1;
    for (College *college in self->initailCollegeList) {
        if ((college.rigorScore) >= convertedScore) {
            [self->filteredList addObject:college];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self filter];
    AccountViewController *accountVC = [segue destinationViewController];
    accountVC.matchedColleges = self->filteredList;
}
@end
