//
//  AccountViewController.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//
#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN
@interface AccountViewController : UIViewController<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) NSMutableArray *matchedColleges;
@end
NS_ASSUME_NONNULL_END
