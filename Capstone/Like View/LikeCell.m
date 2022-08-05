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
    [Translate textToTranslate:self.college.name translatedTextBlock:^(NSString * _Nonnull text) {
        self.likedCollegeName.text = text;
    }];
    [Translate textToTranslate:self.college.location translatedTextBlock:^(NSString * _Nonnull text) {
        self.likedCollegeDescription.text = text;
    }];
    [Translate textToTranslate:self.college.details translatedTextBlock:^(NSString * _Nonnull text) {
        self.likedCollegeDescription.text = text;
    }];
    NSURL *url = [NSURL URLWithString:college.image];
    [self.likedCollegeImage setImageWithURL:url];
    NSLog(@"%@", college.details);
}
@end
