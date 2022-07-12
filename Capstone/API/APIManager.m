//
//  APImanager.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//
#import "CollegeNews.h"
#import "APIManager.h"
#import "College.h"
#import "AFNetworking.h"


@implementation APIManager {
    bool isPrivate;
    bool isPublic;
    bool isSmall;
    bool isLarge;
    NSURL *url;
}

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchColleges: (void(^)(NSArray *colleges, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               completion(nil, error);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSMutableArray *colleges = [College collegesWithArray:[dataDictionary objectForKey:@"colleges"]];
               completion(colleges, nil);
            }}];
    [task resume];
}

- (void)fetchCollegeNews: (void(^)(NSArray *collegeNews, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://newsapi.org/v2/everything?q=University&apiKey=7f0d9c3ee4ac401e8d6a714629947c61"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSMutableArray *collegeNews = [CollegeNews collegesWithArrayNews:[dataDictionary objectForKey:@"articles"]];
               completion(collegeNews,nil);
           }}];
    [task resume];
}

- (void)chosePrivate {
    isPrivate = true;
}

- (void)choseSmall {
    isSmall = true;
}

- (void)chosePublic {
    isPublic = true;
}

- (void)choseLarge {
    isLarge = true;
}

- (void)fetchCollegesForFiltering: (void(^)(NSArray *colleges, NSError *error))completion {
    if (isSmall && isPrivate) {
        url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22private%22%5D%2C%0A%22schoolSize%22%3A%5B%22small%22%5D%2C%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    } else if (isLarge && isPublic) {
        url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22public%22%5D%2C%0A%22schoolSize%22%3A%5B%22large%22%5D%2C%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    } else if (isSmall && isPublic) {
        url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22public%22%5D%2C%0A%22schoolSize%22%3A%5B%22small%22%5D%2C%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    } else {
        url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22private%22%5D%2C%0A%22schoolSize%22%3A%5B%22large%22%5D%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSMutableArray *colleges = [College collegesWithArray:[dataDictionary objectForKey:@"colleges"]];
               completion(colleges,nil);
           }}];
    [task resume];
}
@end
