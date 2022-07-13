//
//  College.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN
@interface College : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *longtuide;
@property (strong, nonatomic) NSString *lat;
@property (nonatomic, assign) double rigorScore;
@property (nonatomic, assign) double distance;
@property (nonatomic) int likeCount;
+ (NSMutableArray *)collegesWithArray:(NSArray *)dictionaries;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
NS_ASSUME_NONNULL_END
