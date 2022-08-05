//
//  LangaugeSelectionTableViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/4/22.
//
#import "LanguageTableViewController.h"
#import <Parse/Parse.h>

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
}

- (IBAction)didTapArabicForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"Arabic";
    [self->currentUser saveInBackground];
}

- (IBAction)didTapGermanForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"German";
    [self->currentUser saveInBackground];
}

- (IBAction)didTapSpanishForNew:(id)sender {
    self->currentUser[@"newLanguage"] = @"Spanish";
    [self->currentUser saveInBackground];
}
@end
