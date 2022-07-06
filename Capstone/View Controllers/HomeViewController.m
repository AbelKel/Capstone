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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSDictionary *allCollegeInfo;
@property(strong, nonatomic) NSArray *colleges;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *collegeNames;
@property (strong, nonatomic) NSMutableArray *collegeCity;
@property (strong, nonatomic) NSMutableArray *collegeDescription;
@property (strong, nonatomic) NSMutableArray *collegeImage;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.collegeNames = [[NSMutableArray alloc]init];
    self.collegeCity = [[NSMutableArray alloc]init];
    self.collegeDescription = [[NSMutableArray alloc]init];
    self.collegeImage = [[NSMutableArray alloc]init];
    [self fetchData];
    
}

// I will move this to the API manafer once I am done testing the filtering
-(void)fetchData {
    NSURL *url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22public%22%5D%2C%0A%22schoolSize%22%3A%5B%22large%22%5D%2C%0A%22zipCode%22%3A%2202111%22%2C%0A%22distanceFromHomeMiles%22%3A%5B0%2C500%5D%2C%0A%22satOverall%22%3A1200%2C%0A%22closeToMyScores%22%3Atrue%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.allCollegeInfo = dataDictionary;
               self.colleges = [dataDictionary objectForKey:@"colleges"]; // has 13 items
               for (int i = 0; i < self.colleges.count; i++) {
                   NSString *city = [[self.colleges objectAtIndex:i]valueForKey:@"city"];
                   NSString *name = [[self.colleges objectAtIndex:i]valueForKey:@"name"];
                   NSString *longDescription = [[self.colleges objectAtIndex:i]valueForKey:@"longDescription"];
                   NSString *campusImage = [[self.colleges objectAtIndex:i]valueForKey:@"campusImage"];
                   if (city!=nil && name!=nil && longDescription!=nil) {
                       [self.collegeCity addObject:city];
                       [self.collegeNames addObject:name];
                       [self.collegeDescription addObject:longDescription];
                       [self.collegeImage addObject:campusImage];
                   }
               }
               [self.tableView reloadData];
            }
           }];
    [task resume];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collegeCity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    cell.homeCollegeName.text = self.collegeNames[indexPath.row];
    cell.homeCollegeDetails.text = self.collegeDescription[indexPath.row];
    NSURL *url = [NSURL URLWithString:self.collegeImage[indexPath.row]];
    [cell.homeCellImage setImageWithURL:url];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    NSString *nameToPass = self.collegeNames[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailName = nameToPass;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
