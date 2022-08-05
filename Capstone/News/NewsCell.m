//
//  NewsCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//
#import "NewsCell.h"
#import "UIImageView+AFNetworking.h"
#import "Translate.h"
@implementation NewsCell
- (void)setCollegeNews:(CollegeNews *)collegeNews {
    [Translate textToTranslate:collegeNews.title translatedTextBlock:^(NSString * _Nonnull text) {
        self.NewsTitle.text = text;
    }];
    [Translate textToTranslate:collegeNews.newsDescription translatedTextBlock:^(NSString * _Nonnull text) {
        self.NewsDescription.text = text;
    }];
    NSURL *url = [NSURL URLWithString:collegeNews.imageUrl];
    [self.NewsImage setImageWithURL:url];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
