//
//  LikeCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//
#import "LikeCell.h"
#import "UIImageView+AFNetworking.h"

@implementation LikeCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCollege:(College *)college {
    self.likedCollegeName.text = college.name;
    self.likedCollegeLocation.text = college.location;
    self.likedCollegeDescription.text = college.details;
    NSURL *url = [NSURL URLWithString:college.image];
    [self.likedCollegeImage setImageWithURL:url];
}
@end
