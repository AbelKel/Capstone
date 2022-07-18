//
//  MatchCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/11/22.
//
#import "MatchCell.h"
@implementation MatchCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)buildMatchCell {
    self.collegeName.text = self.college.name;
}
@end
