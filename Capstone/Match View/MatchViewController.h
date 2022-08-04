//
//  MatchViewController.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MatchViewControllerDelegate <NSObject>

- (void)didMatchColleges:(BOOL)hide;

@end

@interface MatchViewController : UIViewController

@property (nonatomic, readwrite, weak) id<MatchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
