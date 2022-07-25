//
//  LikesRelations.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/23/22.
//
#import "ParseCollege.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface LikesRelations : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFObject *likedCollege;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSString *username;
+ (void)postUserLikes: (College * _Nullable )college forParseCollege:(ParseCollege *_Nullable)parseObject withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
