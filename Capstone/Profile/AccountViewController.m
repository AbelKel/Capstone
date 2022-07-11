//
//  AccountViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//

#import "AccountViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "AFNetworking/AFNetworking.h"
#import <FBSDKCoreKit/FBSDKProfile.h>

@interface AccountViewController () 
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property(strong, nonatomic) NSDictionary *collegeInfo;
@end

@implementation AccountViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
                if(profile) {
                    NSString *lastnameWithSpace = [@" " stringByAppendingString:profile.lastName];
                    NSString *fullName = [profile.firstName stringByAppendingString:lastnameWithSpace];
                    self.profileName.text = fullName;
                    NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(0, 0)];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    [self.profileImage setImage:image];
                }
            }];
        });
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        self.view.window.rootViewController = loginViewController;
    }];
}

-(void)setUser {
    PFUser *username = [PFUser currentUser];
    self.profileName.text = username.username;
}
@end
