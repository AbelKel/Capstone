//
//  NewsCell.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//
#import <UIKit/UIKit.h>
#import "CollegeNews.h"
NS_ASSUME_NONNULL_BEGIN
@interface NewsCell : UITableViewCell
@property (strong, nonatomic) CollegeNews *collegeNews;
@property (weak, nonatomic) IBOutlet UIImageView *NewsImage;
@property (weak, nonatomic) IBOutlet UILabel *NewsTitle;
@property (weak, nonatomic) IBOutlet UILabel *NewsDescription;
@end
NS_ASSUME_NONNULL_END
