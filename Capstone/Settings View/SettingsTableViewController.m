//
//  SettingsTableViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//
#import "SettingsTableViewController.h"
#import "AccountViewController.h"
#import <Parse/Parse.h>
#import "Translate.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *settingsNavItem;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLanLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeLanguageButton;
@property (weak, nonatomic) IBOutlet UILabel *editProfileImageLabel;
@end

@implementation SettingsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [Translate textToTranslate:@"Edit Profile Image" translatedTextBlock:^(NSString * _Nonnull text) {
        self.editProfileImageLabel.text = text;
    }];
    [Translate textToTranslate:@"Change Language" translatedTextBlock:^(NSString * _Nonnull text) {
        self.changeLanLabel.text = text;
    }];
    [Translate textToTranslate:@"About" translatedTextBlock:^(NSString * _Nonnull text) {
        self.aboutLabel.text = text;
    }];
    [Translate textToTranslate:@"Settings" translatedTextBlock:^(NSString * _Nonnull text) {
        self.settingsNavItem.title = text;
    }];
    [Translate textToTranslate:@"Change" translatedTextBlock:^(NSString * _Nonnull text) {
        [self.changeLanguageButton setTitle:text forState:UIControlStateNormal];
    }];
}

- (IBAction)didTapEditProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    PFUser *current = [PFUser currentUser];
    current[@"image"] = [self getPFFileFromImage:editedImage];
    [PFUser.currentUser saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
@end
