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
    NSString *schoolSize;
    NSString *fundingType;
    bool isPublic;
    bool isSmall;
}

- (void)setSchoolSizePreference:(NSString *)schoolSize {
    self->schoolSize = schoolSize;
    if ([self->schoolSize  isEqual: @"small"]) {
        isSmall = true;
    } else {
        isSmall = false;
    }
}

- (void)setSchoolType:(NSString *)schoolType {
    self->fundingType = schoolType;
    if ([self->fundingType  isEqual: @"public"]) {
        isPublic = true;
    } else {
        isPublic = false;
    }
    
}

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchColleges:(void(^)(NSArray *colleges, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *url = [NSURL URLWithString:@"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               completion(nil, error);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSMutableArray *colleges = [College collegesWithArray:[dataDictionary objectForKey:@"colleges"]];
               dispatch_async(dispatch_get_main_queue(), ^{
                   completion(colleges, nil);
               });
            }}];
    [task resume];
    });
}

- (void)fetchCollegeNews:(void(^)(NSArray *collegeNews, NSError *error))completion {
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

- (void)fetchCollegesBasedOnFundingType:(void(^)(NSArray *colleges, NSError *error))completion {
    NSString *stringURL = @"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22__%22%5D%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat";
    stringURL = [stringURL stringByReplacingOccurrencesOfString:@"__"
                                         withString:fundingType];
    NSURL *url = [NSURL URLWithString:stringURL];
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

- (void)fetchCollegesBasedOnSchoolSize:(void(^)(NSArray *colleges, NSError *error))completion {
    NSString *stringURLForSize = @"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22schoolSize%22%3A%5B%22___%22%5D%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat";
    stringURLForSize = [stringURLForSize stringByReplacingOccurrencesOfString:@"___"
                                         withString:schoolSize];
    NSURL *urlForSize = [NSURL URLWithString:stringURLForSize];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:urlForSize cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
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
    });
}

//TODO: fix code reptition above
- (void)queryAPIs:(void(^)(NSArray *collegesBasedonSize, NSArray *collegesBasedonFunding, NSError *error))completion {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        [self fetchCollegesBasedOnSchoolSize:^(NSArray *colleges, NSError *error) {
            self.collegesBasedonSize = colleges;
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        [self fetchCollegesBasedOnFundingType:^(NSArray *colleges, NSError *error) {
            self.collegesBasedonFunding = colleges;
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self.collegesBasedonFunding, self.collegesBasedonSize, nil);
        });
    });
}
@end
