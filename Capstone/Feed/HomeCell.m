//
//  HomeCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import "HomeCell.h"
#import "College.h"
#import "HomeViewController.h"
#import "UIImageView+AFNetworking.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setCollege:(College *)college {
    self.homeCollegeName.text = college.name;
    self.homeCollegeDetails.text = college.details;
    self.homeCollegeLocation.text = college.location;
    NSURL *url = [NSURL URLWithString:college.image];
    [self.homeCellImage setImageWithURL:url];
    [self.homeCollegeName setAlpha:0.f];
    [self.homeCollegeDetails setAlpha:0.f];
    [self.homeCollegeLocation setAlpha:0.f];
    [self.homeCellImage setAlpha:0.f];
     [UIView animateWithDuration:2.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
         [self.homeCollegeName setAlpha:1.f];
         [self.homeCollegeDetails setAlpha:1.f];
         [self.homeCollegeLocation setAlpha:1.f];
         [self.homeCellImage setAlpha:1.f];
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:2.f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
             [self.homeCollegeName setAlpha:2.f];
             [self.homeCollegeDetails setAlpha:2.f];
             [self.homeCollegeLocation setAlpha:2.f];
             [self.homeCellImage setAlpha:2.f];
         } completion:nil];
     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
