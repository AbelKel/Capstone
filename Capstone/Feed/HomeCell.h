//
//  HomeCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeCellImage;
@property (weak, nonatomic) IBOutlet UILabel *homeCollegeName;
@property (weak, nonatomic) IBOutlet UILabel *homeCollegeDetails;
@property (weak, nonatomic) IBOutlet UILabel *homeCollegeLocation;
@property (weak, nonatomic) NSArray *cellDictionary;

@end

NS_ASSUME_NONNULL_END
