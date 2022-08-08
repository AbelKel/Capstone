//
//  NewsDetailsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/31/22.
//

#import "NewsDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Translate.h"

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
    [Translate textToTranslate:self.collegeNews.title translatedTextBlock:^(NSString * _Nonnull text) {
        self.headline.text = text;
    }];
    [Translate textToTranslate:self.collegeNews.newsDescription translatedTextBlock:^(NSString * _Nonnull text) {
        self.newsDescription.text = text;
    }];
    self.headline.text = self.collegeNews.title;
    self.newsDescription.text = self.collegeNews.newsDescription;
    int getCharactersUpTpIndex = 10;
    self.publicationDate.text = [self.collegeNews.publicationDate substringToIndex:getCharactersUpTpIndex];
    self.articleAuthorName.text = self.collegeNews.articleAuthorName;
    NSURL *url = [NSURL URLWithString:self.collegeNews.imageUrl];
    [self.newsCoverImage setImageWithURL:url];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.newsCoverImage setUserInteractionEnabled:YES];
    [self.newsCoverImage addGestureRecognizer:tapGesture];
}

- (IBAction)didTapReadMore:(id)sender {
    [self handleDoubleTap:(UITapGestureRecognizer *)sender];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    NSString *urlString = self.collegeNews.url;
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
       [[UIApplication sharedApplication] openURL:url];
    }
}
@end


