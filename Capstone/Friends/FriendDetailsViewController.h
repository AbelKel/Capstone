//
//  FriendDetailsViewController.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendDetailsViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
