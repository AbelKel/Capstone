//
//  DetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsCollegeImage;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeName;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailsCollegeDetails;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailsCollegeName.text = self.detailName;
    self.detailsCollegeDetails.text = self.detailDetail;
    self.detailsCollegeLocation.text = self.detailLocation;
    NSURL *url = [NSURL URLWithString:self.detailImage];
    [self.detailsCollegeImage setImageWithURL:url];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
