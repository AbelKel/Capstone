//
//  MatchCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/11/22.
//
#import <UIKit/UIKit.h>
#import "College.h"
NS_ASSUME_NONNULL_BEGIN
@interface MatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *collegeName;
@property (strong, nonatomic) College *college;
- (void)buildMatchCell;
@end
NS_ASSUME_NONNULL_END
