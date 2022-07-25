//
//  LongDetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/20/22.
//

#import "LongDetailsViewController.h"

@interface LongDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *longDescription;
@end

@implementation LongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.longDescription.text = self.college.detailsLong;
}

@end
