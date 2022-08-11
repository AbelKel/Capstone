//
//  FriendMatchesCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import "UIImageView+AFNetworking.h"
#import "FriendMatchesCell.h"
#import "Translate.h"
 
@implementation FriendMatchesCell
- (void)setCollege:(ParseCollege *)college {
    [Translate textToTranslate:college.name translatedTextBlock:^(NSString * _Nonnull text) {
        self.collegeNameLabel.text = text;
    }];
    NSURL *url = [NSURL URLWithString:college.image];
    [self.collegeImageView setImageWithURL:url];
}
 
- (void)awakeFromNib {
    [super awakeFromNib];
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
