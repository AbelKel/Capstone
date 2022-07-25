//
//  LikesRelations.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/23/22.
//
#import "ParseCollege.h"
#import "LikesRelations.h"

@implementation LikesRelations

@dynamic author;
@dynamic likedCollege;
@dynamic collegeName;
@dynamic username;

+ (nonnull NSString *)parseClassName {
    return @"LikesRelations";
}


+ (void)postUserLikes: (College * _Nullable )college forParseCollege:(ParseCollege *_Nullable)parseObject withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    LikesRelations *collegeLiked = [LikesRelations new];
    PFUser *current = [PFUser currentUser];
    collegeLiked.author = current;
    collegeLiked.likedCollege = parseObject;
    collegeLiked.collegeName = college.name;
    collegeLiked.username = current.username;
    [collegeLiked saveInBackgroundWithBlock: completion];
    
}
@end
