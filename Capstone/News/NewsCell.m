//
//  NewsCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import "NewsCell.h"
#import "UIImageView+AFNetworking.h"
@implementation NewsCell
- (void)buildNewsCell {
    self.NewsTitle.text = self.collegeNews.title;
    self.NewsDescription.text = self.collegeNews.newsDescription;
    NSURL *url = [NSURL URLWithString:self.collegeNews.imageUrl];
    [self.NewsImage setImageWithURL:url];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
