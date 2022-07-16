//
//  NewsCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//
#import "NewsCell.h"
#import "UIImageView+AFNetworking.h"
@implementation NewsCell
- (void)setCollegeNews:(CollegeNews *)collegeNews {
    self.NewsTitle.text = collegeNews.title;
    self.NewsDescription.text = collegeNews.newsDescription;
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
