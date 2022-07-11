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

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NewsViewController {
    NSMutableArray<CollegeNews *> *collegeArticles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self->collegeArticles = [[NSMutableArray alloc] init];
    [self fetchData];
}

- (void)fetchData {
    [[APIManager shared] fetchCollegeNews:^(NSArray *collegeNews, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self->collegeArticles = (NSMutableArray *)collegeNews;
            NSLog(@"%@", self->collegeArticles);
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->collegeArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    CollegeNews *collegeNews = self->collegeArticles[indexPath.row];
    cell.collegeNews = collegeNews;
    [cell buildNewsCell];
    return cell;
}
@end
