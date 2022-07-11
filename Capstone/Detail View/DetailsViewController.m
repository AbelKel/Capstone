//
//  DetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TTTAttributedLabel.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsCollegeImage;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeName;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeDetails;
@property (weak, nonatomic) IBOutlet UIButton *likeCollege;
@property (weak, nonatomic) IBOutlet UITextView *commentTextField;
@property (weak, nonatomic) IBOutlet UILabel *collegeWebsite;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailsCollegeName.text = self.college.name;;
    self.detailsCollegeDetails.text = self.college.details;
    self.detailsCollegeLocation.text = self.college.location;
    self.collegeWebsite.text = self.college.website;
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.detailsCollegeImage setImageWithURL:url];
}

- (IBAction)didTapLike:(id)sender {
    [self.likeCollege setImage:[UIImage imageNamed:@"favor-icon-red.png"]forState:UIControlStateNormal];
}




@end
