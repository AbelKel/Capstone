//
//  APImanager.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (strong, nonatomic) NSMutableArray *collegeDictionaryArrays;
+ (instancetype)shared;
- (void)fetchColleges: (void(^)(NSArray *colleges, NSError *error))completion;
- (void) fetchCollegeNews: (void(^)(NSArray *collegeNews, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
