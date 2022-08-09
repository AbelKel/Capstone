//
//  ParseCollege.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/22/22.
//

#import <Parse/Parse.h>
#import "College.h"
#import "ParseCollege.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParseCollege : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *detailsLong;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *longtuide;
@property (strong, nonatomic) NSString *lat;
@property (nonatomic, assign) double rigorScore;
@property (nonatomic, assign) double distance;
+ (ParseCollege *)postCollege: (ParseCollege * _Nullable )college withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
