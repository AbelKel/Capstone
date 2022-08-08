//
//  RegistrationViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//
#import <parse/Parse.h>
#import "RegistrationViewController.h"
@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *highSchoolTextField;
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
    newUser[@"age"] = self.ageTextField.text;
    newUser[@"highSchool"] = self.highSchoolTextField.text;
    if ([self.passwordRegistration.text isEqual:self.passwordRegistrationConfirm.text]) {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                [self performSegueToLogin];
            }
        }];
    } else {
        NSString *facebookLoginAlertTilte = @"Passwords do not match!";
        NSString *facebookLoginAlertMessage = @"Please make sure both your passwords match.";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:facebookLoginAlertTilte message:facebookLoginAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didRegisterButton:(id)sender {
    [self registerUser];
}

- (IBAction)didTapCancelRegistration:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)performSegueToLogin {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}
@end
