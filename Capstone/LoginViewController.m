//
//  LoginViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "AccountViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()<RegistrationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;

@end

@implementation LoginViewController

@synthesize fbLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.permissions = @[@"public_profile", @"email"];
    loginButton.center = fbLogin.center;
    [self.view addSubview:loginButton];
    [self performSegueWithIdentifier:@"accountSegue" sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
    [self performSegueWithIdentifier:@"accountSegue" sender:self];
}

- (void)loginUser {

    NSString *username = self.usernameLogin.text;
    NSString *password = self.passwordLogin.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
        }
    }];
}


#pragma mark - FBSDKLoginButton

- (void)loginButton:(FBSDKLoginButton * _Nonnull)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult * _Nullable)result error:(NSError * _Nullable)error {
    if(error) {
        NSLog(@"error, something went wrong");
    } else {
        Acc
        //[self performSegueWithIdentifier:@"accountSegue" sender:nil];
    }
    
}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User logged out");
}

//#pragma mark RegistrationViewControllerDelegate
//-(void)didSaveUsername:(UITextField *)username {
//    _usernameLogin.text = username.text;
//    NSLog(@"%@", username.text);
//    
//}

//#pragma mark RegistrationViewControllerDelegate
//-(void)didSavePassword:(UITextField *)password {
//    _passwordLogin.text = password.text;
//    
//}

- (IBAction)didRegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"regSegue" sender:self];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"regSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        RegistrationViewController *regVC = (RegistrationViewController*)navigationController.topViewController;
        regVC.delegate = self;
    }
}

@end
