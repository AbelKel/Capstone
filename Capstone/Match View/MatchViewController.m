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
    NSArray *initailCollegeList;
    NSString *satScore;
    NSMutableArray *filteredList;
    NSString *city;
    NSString *zipcode;
    NSArray *collegeBasedOnSize;
    NSArray *collegesBasedOnFunding;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->filteredList = [[NSMutableArray alloc] init];
    self->initailCollegeList = [[NSArray alloc] init];
    self->collegeBasedOnSize = [[NSArray alloc] init];
    self->collegesBasedOnFunding = [[NSArray alloc] init];
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
//TODO: start thinking about intersection of chatacteristics
- (void)filter {
    double convertedScore = 50*(1-(([self->satScore doubleValue])/1600))+0.1;
    for (College *college in self->initailCollegeList) {
        if (((college.rigorScore) <= convertedScore) && (college.distance <= [self.distanceInMiles.text doubleValue])) {
            [self->filteredList addObject:college];
        }
    }
    NSSortDescriptor *sortingBasedOnDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    self->filteredList = [self->filteredList sortedArrayUsingDescriptors:@[sortingBasedOnDistance]];
    [self uploadCollegesToParse];
}

/*
 I wanted to only upload colleges that have all the information that a user would need to
 look up a college. That is why you see a long if statement in the uploadCollegesToParse function. It also
 helps avoid the problem of dealing with NSNull. However, making use of a new Schema in the next PR will
 probably improve it. 
 */
- (void)uploadCollegesToParse {
    PFUser *current = [PFUser currentUser];
    PFObject *collegeToParse = [PFObject objectWithClassName:@"MacthedColleges"];
    for (College *college in self->filteredList) {
        if ((college.name != nil) && (college.location != nil) && (college.details != nil) && (college.image != nil) && (college.website != nil)) {
            collegeToParse[@"name"] = college.name;
            collegeToParse[@"city"] = college.location;
            collegeToParse[@"shortDescription"] = college.details;
            collegeToParse[@"longDescription"] = college.detailsLong;
            collegeToParse[@"campusImage"] = college.image;
            collegeToParse[@"website"] = college.website;
            collegeToParse[@"userID"] = current.username;
            [collegeToParse saveEventually];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataForMatches" object:self];
}
@end
