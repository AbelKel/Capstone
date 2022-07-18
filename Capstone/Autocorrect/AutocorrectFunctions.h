//
//  AutocorrectFunctions.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/14/22.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AutocorrectFunctions : NSObject
+ (instancetype)shared;
@property (strong, nonatomic) NSMutableDictionary *keyCoordinates;
- (NSString *)findCorrectWord:(NSString *)searchWord forColleges:(NSArray *)colleges;
- (double)hammingDistanceCalculator:(NSString *)firstWordToCompareOutOfTwoWords secondWordToCompareOutOfTwoWords:(NSString *)secondWordToCompareOutOfTwoWords;
- (double)hammingDistanceHelper:(NSString *)characterFromTheFirstWord characterFromTheSecondWord:(NSString *)characterFromTheSecondWord;
@end
NS_ASSUME_NONNULL_END
