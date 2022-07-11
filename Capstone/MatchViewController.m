//
//  MatchViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/10/22.
//

#import "MatchViewController.h"

@interface MatchViewController ()
@property (weak, nonatomic) IBOutlet UISlider *satSlider;
@property (weak, nonatomic) IBOutlet UILabel *satLabel;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didSlideScore:(id)sender {
    self.satLabel.text = [NSString stringWithFormat:@"%0.0f", self.satSlider.value];
}


@end
