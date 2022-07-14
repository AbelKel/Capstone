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

- (void)buildLikeCell {
    self.likedCollegeName.text = self.college.name;
    self.likedCollegeLocation.text = self.college.location;
    self.likedCollegeDescription.text = self.college.details;
    NSURL *url = [NSURL URLWithString:self.college.image];
    [self.likedCollegeImage setImageWithURL:url];
}
@end
