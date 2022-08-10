//
//  DetailCommentCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/8/22.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *upvoteHeartButton;
@property (weak, nonatomic) IBOutlet UIButton *downvoteHeartButton;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) Comment *comment;
@end

NS_ASSUME_NONNULL_END
