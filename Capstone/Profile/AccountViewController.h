//
//  AccountViewController.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface AccountViewController : UIViewController<FBSDKLoginButtonDelegate>
@property (strong, nonatomic) NSMutableArray *matchedColleges;
@end
NS_ASSUME_NONNULL_END
