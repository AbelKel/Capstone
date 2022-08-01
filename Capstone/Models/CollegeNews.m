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
        self.url = dictionary[@"url"];
        self.content = dictionary[@"content"];
        self.articleAuthorName = dictionary[@"author"];
        self.publicationDate = dictionary[@"publishedAt"];
    }
    return self;
}

+ (NSMutableArray *)collegesWithArrayNews:(NSArray *)dictionaries {
    NSMutableArray *collegeNews = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        if (dictionary[@"title"] != [NSNull null] && dictionary[@"description"] != [NSNull null] && dictionary[@"urlToImage"] != [NSNull null]) {
            CollegeNews *college = [[CollegeNews alloc] initWithDictionaryNews:dictionary];
            [collegeNews addObject:college];
        }
    }
    return collegeNews;
}
@end
