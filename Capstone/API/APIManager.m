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
#import <Parse/Parse.h>

@implementation APIManager {
    NSString *stringURLForSizeOfColleges;
    NSString *stringURLForFundingType;
    NSString *getAllColleges;
}

- (void)setSchoolSizePreference:(NSString *)schoolSize {
    stringURLForSizeOfColleges = @"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22schoolSize%22%3A%5B%22___%22%5D%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat";
    stringURLForSizeOfColleges = [stringURLForSizeOfColleges stringByReplacingOccurrencesOfString:@"___"
                                         withString:schoolSize];
}

- (void)setSchoolType:(NSString *)schoolType {
    stringURLForFundingType = @"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=%7B%0A%22funding-type%22%3A%5B%22__%22%5D%0A%7D&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat";
    stringURLForFundingType = [stringURLForFundingType stringByReplacingOccurrencesOfString:@"__"
                                         withString:schoolType];
}

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchCollegeNews:(NSString *)collegeWebsite getArrayOfCollegeNews:(void(^)(NSArray *collegeNews, NSError *error))completion {
    NSString *stringURLForCollegeNews = @"https://newsapi.org/v2/everything?apiKey=7f0d9c3ee4ac401e8d6a714629947c61&domains=";
    stringURLForCollegeNews = [stringURLForCollegeNews stringByAppendingString:collegeWebsite];
    NSURL *url = [NSURL URLWithString:stringURLForCollegeNews];
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

- (void)fetchCollegesBasedOnFilterPreference:(NSString *)stringURL getArrayOfColleges:(void(^)(NSArray *colleges, NSError *error))completion {
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

- (void)fetchCollegeForSegment:(NSString *)segmentNumber getColleges:(void(^)(NSArray *colleges, NSError *error))completion {
    NSString *segmentStringURL = @"https://api.collegeai.com/v1/api/college-list?api_key=4c4e51cca8832178dcfb29217c&filters=&info_ids=website%2CshortDescription%2ClongDescription%2CcampusImage%2Ccity%2CstateAbbr%2Caliases%2Ccolors%2ClocationLong%2ClocationLat&offset=";
    segmentStringURL = [segmentStringURL stringByAppendingString:segmentNumber];
    NSURL *url = [NSURL URLWithString:segmentStringURL];
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

- (void)queryAPIs:(void(^)(NSArray *collegesBasedonSize, NSArray *collegesBasedonFunding, NSError *error))completion {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        [self fetchCollegesBasedOnFilterPreference:self->stringURLForSizeOfColleges getArrayOfColleges:^(NSArray *colleges, NSError *error) {
            self.collegesBasedonSize = colleges;
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        [self fetchCollegesBasedOnFilterPreference:self->stringURLForFundingType getArrayOfColleges:^(NSArray *colleges, NSError *error) {
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

- (void)getLikedColleges:(PFUser *)user forColleges:(void(^)(NSArray *colleges, NSError *error))completion {
    PFRelation *relation = [user relationForKey:@"likes"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *collegesBasedOnLikes, NSError *error) {
        if (collegesBasedOnLikes != nil) {
            completion(collegesBasedOnLikes, nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
@end
