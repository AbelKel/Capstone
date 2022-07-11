//
//  RegistrationViewController.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RegistrationViewControllerDelegate <NSObject>
-(void)didSaveUsername:(UITextField *)username;
-(void)didSavePassword:(UITextField *)password;
@end
@interface RegistrationViewController : UIViewController
@property (nonatomic, weak) id<RegistrationViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
