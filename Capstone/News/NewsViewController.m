//
//  NewsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//
#import "NewsViewController.h"
#import "CollegeNews.h"
#import "NewsCell.h"
#import "APIManager.h"
#import "ParseCollege.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end
@implementation NewsViewController {
    NSMutableArray<CollegeNews *> *collegeArticles;
    NSString *websitesToGetNewsFrom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self->collegeArticles = [[NSMutableArray alloc] init];
    self->websitesToGetNewsFrom = [[NSString alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchUserLikes) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self fetchUserLikes];
    [self.activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchUserLikes];
}

- (void)fetchUserLikes {
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"likes"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *colleges, NSError *error) {
        if (colleges != nil) {
            NSString* collegeSite;
            for (ParseCollege *college in colleges) {
                collegeSite = [college.website substringFromIndex:4];
                self->websitesToGetNewsFrom = [self->websitesToGetNewsFrom stringByAppendingString:collegeSite];
                self->websitesToGetNewsFrom = [self->websitesToGetNewsFrom stringByAppendingString:@","];
            }
            [self getArticles:self->websitesToGetNewsFrom];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)getArticles:(NSString *)website {
    [[APIManager shared] fetchCollegeNews:website getArrayOfColelgeNews:^(NSArray * _Nonnull collegeNews, NSError * _Nonnull error) {
        self->collegeArticles = collegeNews;
        [self.activityIndicator stopAnimating];
        [self.activityIndicator hidesWhenStopped];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->collegeArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    CollegeNews *collegeNews = self->collegeArticles[indexPath.row];
    cell.collegeNews = collegeNews;
    return cell;
}
@end
