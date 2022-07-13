//
//  SettingsTableViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//

#import "SettingsTableViewController.h"
#import "AccountViewController.h"
#import <Parse/Parse.h>

@interface SettingsTableViewController ()
@end

@implementation SettingsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
