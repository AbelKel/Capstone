//
//  AutocorrectFunctions.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/14/22.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutocorrectFunctions : NSObject

@property (strong, nonatomic) NSMutableDictionary *keyCoordinates;
+ (NSString *)findCorrectWord:(NSString *)searchWord forCollegesInArray:(NSArray *)colleges;

@end

NS_ASSUME_NONNULL_END
