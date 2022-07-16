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
- (NSString *)findCorrectWord:(NSString *)searchWord :(NSArray *)colleges;
- (double)hammingDistanceCalculator:(NSString *)string1 :(NSString *)string2;
- (double)hammingDistanceHelper:(NSString *)character1 :(NSString *)character2;
@end
NS_ASSUME_NONNULL_END
