//
//  DetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import "DetailsViewController.h"

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
