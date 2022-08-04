//
//  LikeCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//
#import "LikeCell.h"
#import "Translate.h"
#import "UIImageView+AFNetworking.h"

@implementation LikeCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCollege:(College *)college {
    [Translate textToTranslate:college.name forText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
        self.likedCollegeName.text = text;
    }];
    [Translate textToTranslate:college.location forText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
        self.likedCollegeLocation.text = text;
    }];
    [Translate textToTranslate:college.details forText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
        self.likedCollegeDescription.text = text;
    }];
    NSURL *url = [NSURL URLWithString:college.image];
    [self.likedCollegeImage setImageWithURL:url];
    NSLog(@"%@", college.details);
}
@end
