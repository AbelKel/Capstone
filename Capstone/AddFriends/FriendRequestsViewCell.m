//
//  FriendRequestsViewCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import <Parse/Parse.h>
#import "FriendRequestsViewCell.h"

@implementation FriendRequestsViewCell
- (void)setUser:(PFUser *)user {
    self.username.text = user.username;
    PFFileObject *userProfileImage = user[@"image"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [userProfileImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.userImage.image = image;
                [self setImageBoarderSize];
            }
        }];
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setImageBoarderSize {
    double radius = 1.788;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/radius;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
}
@end
