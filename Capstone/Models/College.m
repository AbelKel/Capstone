//
//  College.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/7/22.
//

#import "College.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@implementation College 
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.details = dictionary[@"shortDescription"];
        if (dictionary[@"shortDescription"] == nil) {
            self.details = dictionary[@"longDescription"];
        }
        self.location = dictionary[@"city"];
        self.image = dictionary[@"campusImage"];
        self.website = dictionary[@"website"];
        self.longtuide = dictionary[@"locationLong"];
        self.lat = dictionary[@"locationLat"];
        self.rigorScore = [dictionary[@"score"] doubleValue];
        self.likeCount = 0;
        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[dictionary[@"locationLat"] doubleValue] longitude:[dictionary[@"locationLong"] doubleValue]];
        CLLocationCoordinate2D coordinate = [self getLocation];
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
        double const convertingMetersToMiles = 1609.34;
        self.distance = (distance/convertingMetersToMiles);
    }
    return self;
}

- (CLLocationCoordinate2D)getLocation {
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    self->locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self->locationManager.distanceFilter = kCLDistanceFilterNone;
    if (([self->locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        [self->locationManager requestWhenInUseAuthorization];
    }
    [self->locationManager startUpdatingLocation];
    CLLocation *location = [self->locationManager location];
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
