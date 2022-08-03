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
    [userProfileImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.userImage.image = image;
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
