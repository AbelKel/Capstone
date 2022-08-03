//
//  FriendRequestsViewCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequestsViewCell : UITableViewCell
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@end

NS_ASSUME_NONNULL_END
