//
//  College.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import "College.h"

@implementation College

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.details = dictionary[@"shortDescription"];
        self.location = dictionary[@"city"];
        self.image = dictionary[@"campusImage"];
        self.website = dictionary[@"website"];
    }
    return self;
}

+ (NSMutableArray *)collegesWithArray:(NSArray *)dictionaries {
    NSMutableArray *colleges = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        College *college = [[College alloc] initWithDictionary:dictionary];
        [colleges addObject:college];
    }
    return colleges;
}


@end
