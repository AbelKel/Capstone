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
@synthesize fbLogoutView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
#pragma mark


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
