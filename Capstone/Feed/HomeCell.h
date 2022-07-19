//
//  HomeCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//
#import <UIKit/UIKit.h>
#import "College.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell

@property (strong, nonatomic) College *college;
@property (weak, nonatomic) IBOutlet UIImageView *homeCellImage;
@property (weak, nonatomic) IBOutlet UILabel *homeCollegeName;
@property (weak, nonatomic) IBOutlet UILabel *homeCollegeDetails;
@property (weak, nonatomic) IBOutlet UILabel *homeCollegeLocation;

@end

NS_ASSUME_NONNULL_END
