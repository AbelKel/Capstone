//
//  FriendMatchesCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import "ParseCollege.h"
#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN
 
@interface FriendMatchesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collegeImageView;
@property (nonatomic, strong) ParseCollege *college;
@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;
@end
 
NS_ASSUME_NONNULL_END
