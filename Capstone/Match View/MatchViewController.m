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
#import "ParseCollege.h"
#import <Parse/Parse.h>

@interface MatchViewController ()

@property (weak, nonatomic) IBOutlet UISlider *satSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeProperty;
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSize;
@property (weak, nonatomic) IBOutlet UILabel *satLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceFromCurrentLocation;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *distanceInMiles;

@end

@implementation MatchViewController {
    NSArray<College *> *initailCollegeList;
    NSString *satScore;
    NSMutableArray<College *> *filteredList;
    NSString *city;
    NSString *zipcode;
    NSArray<College *> *collegeBasedOnSize;
    NSArray<College *> *collegesBasedOnFunding;
    PFUser *currentUser;
    PFRelation *matchesRelation;
    ParseCollege *collegeFromParse;
    int indexInArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->filteredList = [[NSMutableArray alloc] init];
    self->initailCollegeList = [[NSArray alloc] init];
    self->collegeBasedOnSize = [[NSArray alloc] init];
    self->collegesBasedOnFunding = [[NSArray alloc] init];
    self->currentUser = [PFUser currentUser];
    self->matchesRelation = [self->currentUser relationForKey:@"matches"];
}

- (void)fetchData {
    [[APIManager shared] queryAPIs:^(NSArray * _Nonnull collegesBasedonSize, NSArray * _Nonnull collegesBasedonFunding, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self->collegeBasedOnSize = collegesBasedonSize;
            self->collegesBasedOnFunding = collegesBasedonFunding;
            self->initailCollegeList = [self->initailCollegeList arrayByAddingObjectsFromArray:self->collegesBasedOnFunding];
            self->initailCollegeList = [self->initailCollegeList arrayByAddingObjectsFromArray:self->collegeBasedOnSize];
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
            [[APIManager shared] setSchoolType:@"public"];
            break;
        case 1:
            [[APIManager shared] setSchoolType:@"private"];
            break;
    }
}

- (IBAction)didSlideDistanceFromCurrent:(id)sender {
    self.distanceInMiles.text = [NSString stringWithFormat:@"%0.0f", self.distanceFromCurrentLocation.value];
}


- (IBAction)segemntedControlCity:(id)sender {
    switch (self.collegeSize.selectedSegmentIndex) {
        case 0:
            [[APIManager shared] setSchoolSizePreference:@"small"];
            break;
        case 1:
            [[APIManager shared] setSchoolSizePreference:@"large"];
            break;
    }
}

- (IBAction)didTapAddCity:(id)sender {
    self->city = self.cityField.text;
}

- (IBAction)filterButton:(id)sender {
    [self fetchData];
}

- (IBAction)didTapDone:(id)sender {
    [self filter];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

/**
 The lowest rigor score for a college can go as high as upto 50.
 The highest rigor score is 0.1
 The SAT score to Rigor Score conversion would be 50(1-(x/1600)) +0.1
 - parameters to consider (college.location == self.city) &&
 - college.distance < 1000
*/
//TODO: I will be adding a boolean value for college size & funding to make the filtering accurate in the next PR
- (void)filter {
    int maxNumberOfMatches = 10;
    double convertedScore = 50*(1-(([self->satScore doubleValue])/1600))+0.1;
    NSSortDescriptor *sortingBasedOnDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:NO];
    self->initailCollegeList = [self->initailCollegeList sortedArrayUsingDescriptors:@[sortingBasedOnDistance]];
    for (College *college in self->initailCollegeList) {
        if (self->filteredList.count == maxNumberOfMatches) {
            break;
        } else if (((college.rigorScore) <= convertedScore) && (college.distance <= [self.distanceInMiles.text doubleValue] && ![self->filteredList containsObject:college])) {
            [self->filteredList addObject:college];
        } else if ([self->city isEqual:college.location] && ![self->filteredList containsObject:college]) {
            [self->filteredList addObject:college];
        }
    }
    [self constantBackoff];
}

- (void)constantBackoff {
    int constantBackoffTimeInterval = 3.0;
    [NSTimer scheduledTimerWithTimeInterval:constantBackoffTimeInterval target:self selector:@selector(getCollegesInParse:) userInfo:nil repeats:YES];
}

- (void)getCollegesInParse:(NSTimer *)timer {
    int indexCorrection = 1;
    if (indexInArray < self->filteredList.count-indexCorrection) {
        PFQuery *query = [PFQuery queryWithClassName:@"Colleges"];
        College *college = [self->filteredList objectAtIndex:indexInArray];
        [query whereKey:@"name" equalTo:college.name];
        NSInteger collegeMatches = [query countObjects];
        if (collegeMatches == 1) {
            [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
                self->collegeFromParse = [colleges objectAtIndex:0];
                [self->matchesRelation addObject:self->collegeFromParse];
                [self->currentUser saveInBackground];
            }];
            collegeMatches = 0;
        } else {
            ParseCollege *currentCollege = [ParseCollege postCollege:college withCompletion:^(BOOL succeeded, NSError * _Nullable error) {}];
            [currentCollege save];
            [self->matchesRelation addObject:currentCollege];
            [self->currentUser saveInBackground];
        }
        indexInArray++;
    } else {
        [timer invalidate];
    }
}
@end
