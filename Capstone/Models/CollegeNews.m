//
//  CollegeNews.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/10/22.
//

#import "CollegeNews.h"

@implementation CollegeNews
- (instancetype)initWithDictionaryNews:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.newsDescription = dictionary[@"description"];
        self.imageUrl = dictionary[@"urlToImage"];
    }
    return self;
}

+ (NSMutableArray *)collegesWithArrayNews:(NSArray *)dictionaries {
    NSMutableArray *collegeNews = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        CollegeNews *college = [[CollegeNews alloc] initWithDictionaryNews:dictionary];
        [collegeNews addObject:college];
    }
    return collegeNews;
}
@end
