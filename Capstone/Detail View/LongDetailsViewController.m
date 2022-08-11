//
//  LongDetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/20/22.
//

#import "LongDetailsViewController.h"
#import "Translate.h"

@interface LongDetailsViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *longDescriptionNav;
@property (weak, nonatomic) IBOutlet UILabel *longDescription;
@end

@implementation LongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.college.details == nil) {
        self.longDescription.text = @"This college does not have a description. Please go to their website to learn more.";
    } else {
        [Translate textToTranslate:self.college.detailsLong translatedTextBlock:^(NSString * _Nonnull text) {
            self.longDescription.text = text;
        }];
    }
    [Translate textToTranslate:@"Long Description" translatedTextBlock:^(NSString * _Nonnull text) {
        self.longDescriptionNav.title = text;
    }];
}

@end
