//
//  Comment.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/21/22.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *college;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *usernameForDisplaying;
@property (nonatomic) int vote;
+ (void)postUserComment: (NSString * _Nullable )comment underCollege: ( NSString * _Nullable )collegeName withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
