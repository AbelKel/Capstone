//
//  HomeViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/4/22.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "APIManager.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic) NSArray<NSDictionary *> *colleges;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *collegeDictionaryArrays;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredColleges;

@end

bool isFiltered;

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    isFiltered = false;
    self.collegeDictionaryArrays = [[NSMutableArray alloc] init];
    [self fetchData];
}

- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.colleges = [dataDictionary objectForKey:@"colleges"];
               for (NSDictionary<NSString *, NSString *> *college in self.colleges) {
                   [self.collegeDictionaryArrays addObject:college];
               }
               [self.tableView reloadData];
            }}];
    [task resume];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isFiltered = false;
    } else {
        isFiltered = true;
        self.filteredColleges = [[NSMutableArray alloc] init];
        for (NSDictionary<NSString *, NSString *> *college in self.colleges) {
            NSRange collegeName = [college[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (collegeName.location != NSNotFound) {
                [self.filteredColleges addObject:college];
            }
        }
    }
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return self.filteredColleges.count;
    }
    return self.collegeDictionaryArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (isFiltered) {
        cell.homeCollegeName.text = self.filteredColleges[indexPath.row][@"name"];
        cell.homeCollegeDetails.text = self.filteredColleges[indexPath.row][@"shortDescription"];
        cell.homeCollegeLocation.text = self.filteredColleges[indexPath.row][@"city"];
        NSURL *url = [NSURL URLWithString:self.filteredColleges[indexPath.row][@"campusImage"]];
        [cell.homeCellImage setImageWithURL:url];
    } else {
        cell.homeCollegeName.text = self.collegeDictionaryArrays[indexPath.row][@"name"];
        cell.homeCollegeDetails.text = self.collegeDictionaryArrays[indexPath.row][@"shortDescription"];
        cell.homeCollegeLocation.text = self.collegeDictionaryArrays[indexPath.row][@"city"];
        NSURL *url = [NSURL URLWithString:self.collegeDictionaryArrays[indexPath.row][@"campusImage"]];
        [cell.homeCellImage setImageWithURL:url];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    NSString *nameToPass = self.collegeDictionaryArrays[myIndexPath.row][@"name"];
    NSString *detailToPass = self.collegeDictionaryArrays[myIndexPath.row][@"shortDescription"];
    NSString *cityToPass = self.collegeDictionaryArrays[myIndexPath.row][@"city"];
    NSString *imageToPass = self.collegeDictionaryArrays[myIndexPath.row][@"campusImage"];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailName = nameToPass;
    detailVC.detailDetail = detailToPass;
    detailVC.detailLocation = cityToPass;
    detailVC.detailImage = imageToPass;
}

@end
