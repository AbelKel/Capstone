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

-(void)buildCell {
    self.homeCollegeName.text = self.college.name;
    self.homeCollegeDetails.text = self.college.details;
    self.homeCollegeLocation.text = self.college.location;
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.homeCellImage setImageWithURL:url];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
