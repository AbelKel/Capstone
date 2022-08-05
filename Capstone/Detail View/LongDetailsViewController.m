//
//  LongDetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/20/22.
//

#import "LongDetailsViewController.h"
#import "Translate.h"

@interface LongDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *longDescription;
@end

@implementation LongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Translate textToTranslate:self.college.detailsLong translatedTextBlock:^(NSString * _Nonnull text) {
        self.longDescription.text = text;
    }];
}

@end
