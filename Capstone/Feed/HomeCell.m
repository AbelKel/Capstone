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
#import "Translate.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCollege:(College *)college {
    float const animationDuration = 1.f;
    float const animationDelay = 0.f;
    float const animationFadeInInterval = 2.f;
    
    [Translate textToTranslate:college.name translatedTextBlock:^(NSString * _Nonnull text) {
        self.homeCollegeName.text = text;
    }];
    if (college.details == nil) {
        self.homeCollegeDetails.text = @"This college does not have a description. Please go to their website to learn more.";
    } else {
        [Translate textToTranslate:college.details translatedTextBlock:^(NSString * _Nonnull text) {
            self.homeCollegeDetails.text = text;
        }];
    }
    [Translate textToTranslate:college.location translatedTextBlock:^(NSString * _Nonnull text) {
        self.homeCollegeLocation.text = text;
    }];

    NSURL *url = [NSURL URLWithString:college.image];
    [self.homeCellImage setImageWithURL:url];
    
    [self.homeCollegeName setAlpha:animationDelay];
    [self.homeCollegeDetails setAlpha:animationDelay];
    [self.homeCollegeLocation setAlpha:animationDelay];
    [self.homeCellImage setAlpha:animationDelay];
    [UIView animateWithDuration:animationDuration delay:animationDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.homeCollegeName setAlpha:animationFadeInInterval];
        [self.homeCollegeDetails setAlpha:animationFadeInInterval];
        [self.homeCollegeLocation setAlpha:animationFadeInInterval];
        [self.homeCellImage setAlpha:animationFadeInInterval];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration delay:animationDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.homeCollegeName setAlpha:animationDuration];
            [self.homeCollegeDetails setAlpha:animationDuration];
            [self.homeCollegeLocation setAlpha:animationDuration];
            [self.homeCellImage setAlpha:animationDuration];
        } completion:nil];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
