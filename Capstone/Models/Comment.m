//
//  Comment.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/21/22.
//

#import "Comment.h"
#import <Parse/Parse.h>

@implementation Comment

@dynamic author;
@dynamic comment;
@dynamic college;
@dynamic image;
@dynamic usernameForDisplaying;

+ (nonnull NSString *)parseClassName {
    return @"Comments";
}

+ (void)postUserComment: (NSString * _Nullable )comment underCollege: ( NSString * _Nullable )collegeName withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Comment *newComment = [Comment new];
    PFUser *current = [PFUser currentUser];
    newComment.author = current;
    newComment.comment = comment;
    newComment.college = collegeName;
    if (current[@"image"] != nil) {
        newComment.image = current[@"image"];
        [PFUser.currentUser saveInBackground];
    }
    newComment.usernameForDisplaying = current.username;
    [newComment saveInBackgroundWithBlock: completion];
}

@end
