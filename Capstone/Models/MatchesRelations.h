//
//  MatchesRelations.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/24/22.
//
#import "College.h"
#import <Parse/Parse.h>
#import "ParseCollege.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchesRelations : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFObject *matchedCollege;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSString *username;
+ (void)postUserMatches: (College * _Nullable )college forParseCollege:(ParseCollege *_Nullable)parseObject withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
