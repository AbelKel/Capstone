//
//  CommentCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//
#import "CommentCell.h"
#import "Comment.h"
#import "AFNetworking/AFNetworking.h"

@implementation CommentCell

- (void)setCommentPosted:(Comment *)commentPosted {
    self.username.text = commentPosted.usernameForDisplaying;
    self.comment.text = commentPosted.comment;
    NSDate *commentTime = commentPosted.createdAt;
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    formatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSString *elapsed = [formatter stringFromDate:commentTime toDate:[NSDate date]];
    self.timeCommentedAt.text = elapsed;
    self.userImage.file = commentPosted.image;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/1.995;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
    [self.userImage loadInBackground];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
