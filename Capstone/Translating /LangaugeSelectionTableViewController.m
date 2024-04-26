//
//  LangaugeSelectionTableViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/4/22.
//
# import "LangaugeSelectionTableViewController.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface LanguageTableViewController ()

@end

@implementation LanguageTableViewController {
    PFUser *currentUser;
}

- (void)viewDidLoad {
    self->currentUser = [PFUser currentUser];
}

- (IBAction)didTapEnglishForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"English";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapArabicForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"Arabic";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapGermanForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"German";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapSpanishForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"Spanish";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapAfrikaans:(id)sender {
    self->currentUser[@"newLanguage"] = @"Afrikaans";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapHindi:(id)sender {
    self->currentUser[@"newLanguage"] = @"Hindi";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapRussian:(id)sender {
    self->currentUser[@"newLanguage"] = @"Russian";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapItalian:(id)sender {
    self->currentUser[@"newLanguage"] = @"Italian";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapJapanese:(id)sender {
    self->currentUser[@"newLanguage"] = @"Japanese";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapChinese:(id)sender {
    self->currentUser[@"newLanguage"] = @"Chinese";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (IBAction)didTapFrench:(id)sender {
    self->currentUser[@"newLanguage"] = @"French";
    [self->currentUser saveInBackground];
    [self languageChangedAlert];
}

- (void)languageChangedAlert {
    NSString *languageChangedAlertTilte = @"Changed Language";
    NSString *changeAlertMessage = @"You have succesfully changed the language of the app.";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:languageChangedAlertTilte message:changeAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
