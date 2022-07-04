//
//  AccountViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//

#import "AccountViewController.h"
#import <FBSDKCoreKit/FBSDKProfile.h>


@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if(profile) {
                self.navigationItem.title = [NSString stringWithFormat:@"Hello %@ %@", profile.firstName, profile.lastName];
                NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(0, 0)];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                
                UIView *profileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
                profileView.layer.cornerRadius = profileView.frame.size.width/2;
                profileView.clipsToBounds = YES;
                profileView.userInteractionEnabled = YES;
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething)];
                [profileView addGestureRecognizer:gestureRecognizer];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [profileView addSubview:imageView];
                
                UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:profileView];
                self.navigationItem.rightBarButtonItem = buttonItem;
                
            }
        }];
    });
}


#pragma mark - Helper Methods

-(void) doSomething {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
