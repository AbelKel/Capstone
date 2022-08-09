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
    [Translate textToTranslate:college.name translatedTextBlock:^(NSString * _Nonnull text) {
        self.likedCollegeName.text = text;
    }];
    [Translate textToTranslate:college.location translatedTextBlock:^(NSString * _Nonnull text) {
        self.likedCollegeLocation.text = text;
    }];
    NSString *textForBlankDescription;
    if (college.details == nil) {
        textForBlankDescription = @"This college does not have a description. Please go to their website to learn more.";
    } else {
        textForBlankDescription = college.details;
    }
    [Translate textToTranslate:textForBlankDescription translatedTextBlock:^(NSString * _Nonnull text) {
        self.likedCollegeDescription.text = text;
    }];
    NSURL *url = [NSURL URLWithString:college.image];
    [self.likedCollegeImage setImageWithURL:url];
    NSLog(@"%@", college.details);
}
@end
