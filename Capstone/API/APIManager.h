//
//  APImanager.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
