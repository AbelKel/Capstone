//
//  LoginViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "AccountViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;
@property (weak, nonatomic) IBOutlet UIView *fbLogin;
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
    [self performSegueWithIdentifier:@"homeSegue" sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
    [self performSegueWithIdentifier:@"homeSegue" sender:self];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (void)loginUser {
    NSString *username = self.usernameLogin.text;
    NSString *password = self.passwordLogin.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapOnBlankSpace:(id)sender {
    [self.view endEditing:true];
}

#pragma mark - FBSDKLoginButton
- (void)loginButton:(FBSDKLoginButton * _Nonnull)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult * _Nullable)result error:(NSError * _Nullable)error {
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        [self performSegueWithIdentifier:@"homeSegue" sender:nil];
        [self.view addSubview:loginButton];
    }
}

- (IBAction)didRegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"regSegue" sender:self];
}
@end
