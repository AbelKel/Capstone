//
//  APImanager.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//
#import <Foundation/Foundation.h>
#import "College.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (strong, nonatomic) NSArray<College *> *collegesBasedonSize;
@property (strong, nonatomic) NSArray<College *> *collegesBasedonFunding;
@property (strong, nonatomic) NSArray<College *> *allColleges;
- (void)setSchoolSizePreference:(NSString *)schoolSize;
- (void)setSchoolType:(NSString *)schoolType;
+ (instancetype)shared;
- (void)fetchCollegeNews:(NSString *)collegeWebsite getArrayOfColelgeNews:(void(^)(NSArray *collegeNews, NSError *error))completion;
- (void)fetchCollegesBasedOnFilterPreference:(NSString *)stringURL getArrayOfColleges:(void(^)(NSArray *colleges, NSError *error))completion;
- (void)queryAPIs:(void(^)(NSArray *colleges, NSArray *colleges1, NSError *error))completion;
- (void)fetchCollegeForSegment:(NSString *)segmentNumber getColleges:(void(^)(NSArray *colleges, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
