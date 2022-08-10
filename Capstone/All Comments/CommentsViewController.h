//
//  CommentsViewController.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/8/22.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : UITableViewController
@property (nonatomic, strong) NSArray<Comment *> *comments;
@end

NS_ASSUME_NONNULL_END
