//
//  NewsDetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/31/22.
//

#import "NewsDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface NewsDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *articleAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *publicationDate;
@property (weak, nonatomic) IBOutlet UIImageView *newsCoverImage;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@end

@implementation NewsDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headline.text = self.collegeNews.title;
    self.newsDescription.text = self.collegeNews.newsDescription;
    self.publicationDate.text = self.collegeNews.publicationDate;
    self.articleAuthorName.text = self.collegeNews.articleAuthorName;
    NSURL *url = [NSURL URLWithString:self.collegeNews.imageUrl];
    [self.newsCoverImage setImageWithURL:url];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.newsCoverImage setUserInteractionEnabled:YES];
    [self.newsCoverImage addGestureRecognizer:tapGesture];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    NSString *urlString = self.collegeNews.url;
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
       [[UIApplication sharedApplication] openURL:url];
    }
}
@end


