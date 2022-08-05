//
//  MatchCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/11/22.
//

#import "MatchCell.h"
#import "UIImageView+AFNetworking.h"
#import "Translate.h"

@implementation MatchCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCollege:(College *)college {
    [Translate textToTranslate:college.name translatedTextBlock:^(NSString * _Nonnull text) {
        self.collegeName.text = text;
    }];
    NSURL *url = [NSURL URLWithString:college.image];
    [self.macthedCollegeImage setImageWithURL:url];
}
@end
