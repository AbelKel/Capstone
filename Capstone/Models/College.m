//
//  College.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import "College.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation College

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.details = dictionary[@"shortDescription"];
        self.location = dictionary[@"city"];
        self.image = dictionary[@"campusImage"];
        self.website = dictionary[@"website"];
        self.longtuide = dictionary[@"locationLong"];
        self.lat = dictionary[@"locationLat"];
        self.rigorScore = [dictionary[@"score"] doubleValue];
        self.likeCount = 0;
        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[dictionary[@"locationLong"] doubleValue] longitude:[dictionary[@"locationLat"] doubleValue]];
        CLLocationCoordinate2D coordinate = [self getLocation];
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
        self.distance = (distance/1609.34);
    }
    return self;
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
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
