//
//  LikeCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "College.h"
NS_ASSUME_NONNULL_BEGIN

@interface LikeCell : UITableViewCell
@property (strong, nonatomic) College *college;
@property (weak, nonatomic) IBOutlet UIImageView *likedCollegeImage;
@property (weak, nonatomic) IBOutlet UILabel *likedCollegeName;
@property (weak, nonatomic) IBOutlet UILabel *likedCollegeLocation;
@property (weak, nonatomic) IBOutlet UILabel *likedCollegeDescription;
- (void)buildLikeCell;
@end

NS_ASSUME_NONNULL_END
