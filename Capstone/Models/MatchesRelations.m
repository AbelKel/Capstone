//
//  MatchesRelations.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/24/22.
//

#import "College.h"
#import "MatchesRelations.h"

@implementation MatchesRelations

@dynamic author;
@dynamic matchedCollege;
@dynamic collegeName;
@dynamic username;

+ (nonnull NSString *)parseClassName {
    return @"MatchesRelations";
}


+ (void)postUserMatches: (College * _Nullable )college forParseCollege:(ParseCollege *_Nullable)parseObject withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    MatchesRelations *collegeLiked = [MatchesRelations new];
    PFUser *current = [PFUser currentUser];
    collegeLiked.author = current;
    collegeLiked.matchedCollege = parseObject;
    collegeLiked.collegeName = college.name;
    collegeLiked.username = current.username;
    [collegeLiked saveInBackgroundWithBlock: completion];
    
}

@end
