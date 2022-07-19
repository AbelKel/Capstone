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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
