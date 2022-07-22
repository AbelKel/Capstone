//
//  CommentCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//
#import <UIKit/UIKit.h>
#import "Comment.h"
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *timeCommentedAt;
@property (weak, nonatomic) Comment *commentPosted;
@end
NS_ASSUME_NONNULL_END
