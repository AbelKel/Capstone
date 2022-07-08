//
//  College.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface College : NSObject

@property (strong, nonatomic) NSString *detailName;
@property (strong, nonatomic) NSString *detailImage;
@property (strong, nonatomic) NSString *detailLocation;
@property (strong, nonatomic) NSString *detailDetail;


- (instancetype)initWithDictionary:(NSArray *)dictionary;


@end

NS_ASSUME_NONNULL_END
