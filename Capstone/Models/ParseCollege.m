//
//  ParseCollege.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/22/22.
//

#import "ParseCollege.h"
#import <Parse/Parse.h>

@implementation ParseCollege

@dynamic author;
@dynamic name;
@dynamic image;
@dynamic location;
@dynamic details;
@dynamic detailsLong;
@dynamic website;
@dynamic longtuide;
@dynamic lat;
@dynamic rigorScore;
@dynamic distance;

+ (nonnull NSString *)parseClassName {
    return @"Colleges";
}

+ (ParseCollege *)postCollege:(College * _Nullable )college withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    ParseCollege *collegeToParse = [ParseCollege new];
    PFUser *current = [PFUser currentUser];
    collegeToParse.author = current;
    collegeToParse.name = college.name;
    collegeToParse.image = college.image;
    collegeToParse.location = college.location;
    collegeToParse.details = college.details;
    collegeToParse.detailsLong = college.detailsLong;
    collegeToParse.website =  college.website;
    collegeToParse.longtuide = college.longtuide;
    collegeToParse.lat = college.lat;
    collegeToParse.rigorScore = college.rigorScore;
    collegeToParse.distance = college.distance;
    [collegeToParse saveInBackgroundWithBlock: completion];
    return collegeToParse;
}
@end
