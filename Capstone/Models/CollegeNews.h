//
//  CollegeNews.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/10/22.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollegeNews : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *newsDescription;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *articleAuthorName;
@property (strong, nonatomic) NSString *publicationDate;
- (instancetype)initWithDictionaryNews:(NSDictionary *)dictionary;
+ (NSMutableArray *)collegesWithArrayNews:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
