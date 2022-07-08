//
//  NewsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import "NewsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NewsCell.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) NSMutableArray<NSDictionary *> *collegeNews;
@property(strong, nonatomic) NSMutableArray *college1;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.college1 = [[NSMutableArray alloc] init];
    [self fetchData];
}

- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"https://newsapi.org/v2/everything?q=University&apiKey=7f0d9c3ee4ac401e8d6a714629947c61"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.collegeNews = [dataDictionary objectForKey:@"articles"];
               for (NSDictionary<NSString *, NSString *> *college in self.collegeNews) {
                   [self.college1 addObject:college];
                   NSLog(@"%@", college);
               }
               [self.tableView reloadData];
            }}];
    [task resume];
    NSLog(@"%@123", self.college1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.college1.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    cell.NewsTitle.text = self.college1[indexPath.row][@"title"];
    cell.NewsDescription.text = self.college1[indexPath.row][@"description"];
    NSURL *url = [NSURL URLWithString:self.college1[indexPath.row][@"urlToImage"]];
    [cell.NewsImage setImageWithURL:url];
    return cell;
}

@end
