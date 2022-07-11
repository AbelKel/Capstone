//
//  College.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface College : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *website;
+ (NSMutableArray *)collegesWithArray:(NSArray *)dictionaries;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
NS_ASSUME_NONNULL_END
