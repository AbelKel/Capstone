//
//  RegistrationViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//
#import <parse/Parse.h>
#import "RegistrationViewController.h"

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameRegistrationField;
@property (weak, nonatomic) IBOutlet UITextField *emailRegistration;
@property (weak, nonatomic) IBOutlet UITextField *passwordRegistration;
@property (weak, nonatomic) IBOutlet UITextField *passwordRegistrationConfirm;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameRegistrationField.text;
    newUser.email = self.emailRegistration.text;
    newUser.password = self.passwordRegistration.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueToLogin];
        }
    }];
}

- (IBAction)didRegisterButton:(id)sender {
    [self registerUser];
}


- (void)performSegueToLogin {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
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
