//
//  MatchCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/11/22.
//

#import "MatchCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MatchCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCollege:(College *)college {
    self.collegeName.text = college.name;
    NSURL *url = [NSURL URLWithString:college.image];
    [self.macthedCollegeImage setImageWithURL:url];
}
@end
