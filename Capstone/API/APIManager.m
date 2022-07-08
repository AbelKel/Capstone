//
//  APImanager.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/5/22.
//

#import "APIManager.h"

@implementation APIManager


+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


@end
