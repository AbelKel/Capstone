//
//  AutocorrectFunctions.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/14/22.
//

#import "AutocorrectFunctions.h"
#include "math.h"

@implementation AutocorrectFunctions
+ (instancetype)shared {
    AutocorrectFunctions *shared= [[AutocorrectFunctions alloc] init];
    return shared;
}

- (void)createCoordinates {
    [self.keyCoordinates setObject:@"00" forKey:@"q"];
    [self.keyCoordinates setObject:@"10" forKey:@"w"];
    [self.keyCoordinates setObject:@"20" forKey:@"e"];
    [self.keyCoordinates setObject:@"30" forKey:@"r"];
    [self.keyCoordinates setObject:@"40" forKey:@"t"];
    [self.keyCoordinates setObject:@"50" forKey:@"y"];
    [self.keyCoordinates setObject:@"60" forKey:@"u"];
    [self.keyCoordinates setObject:@"70" forKey:@"i"];
    [self.keyCoordinates setObject:@"80" forKey:@"o"];
    [self.keyCoordinates setObject:@"90" forKey:@"p"];
    [self.keyCoordinates setObject:@"01" forKey:@"a"];
    [self.keyCoordinates setObject:@"11" forKey:@"s"];
    [self.keyCoordinates setObject:@"21" forKey:@"d"];
    [self.keyCoordinates setObject:@"31" forKey:@"f"];
    [self.keyCoordinates setObject:@"41" forKey:@"g"];
    [self.keyCoordinates setObject:@"51" forKey:@"h"];
    [self.keyCoordinates setObject:@"61" forKey:@"j"];
    [self.keyCoordinates setObject:@"71" forKey:@"k"];
    [self.keyCoordinates setObject:@"81" forKey:@"l"];
    [self.keyCoordinates setObject:@"02" forKey:@"z"];
    [self.keyCoordinates setObject:@"12" forKey:@"x"];
    [self.keyCoordinates setObject:@"22" forKey:@"c"];
    [self.keyCoordinates setObject:@"32" forKey:@"v"];
    [self.keyCoordinates setObject:@"42" forKey:@"b"];
    [self.keyCoordinates setObject:@"52" forKey:@"n"];
    [self.keyCoordinates setObject:@"65" forKey:@"m"];
}

- (double)hammingDistance:(NSString *)string1 :(NSString *)string2 {
    double sum = 0;
    int l1 = string1.length;
    int l2 = string2.length;
    if (string1.length == string2.length) {
        for (int i = 0; i < [string1 length]; i++) {
            NSString *character1 = [string1 substringWithRange:NSMakeRange(i, 1)];
            NSString *character2 = [string2 substringWithRange:NSMakeRange(i, 1)];
            sum += [self hammingDistance2:character1 :character2];
        }
    } else if (l1>l2) {
            for (int i = 0; i < [string2 length]; i++) {
                NSString *character1 = [string1 substringWithRange:NSMakeRange(i, 1)];
                NSString *character2 = [string2 substringWithRange:NSMakeRange(i, 1)];
                sum += [self hammingDistance2:character1 :character2];
        }
        sum += (l1-l2)*10;
    } else {
        for (int i = 0; i < [string1 length]; i++) {
            NSString *character1 = [string1 substringWithRange:NSMakeRange(i, 1)];
            NSString *character2 = [string2 substringWithRange:NSMakeRange(i, 1)];
            sum += [self hammingDistance2:character1 :character2];
      }
        sum += (l2-l1)*10;
    }
    return sum;
}

- (double)hammingDistance2:(NSString *)character1 :(NSString *)character2 {
    double characterDistanceSum = 0;
    NSString *char1Coordinate = [self.keyCoordinates objectForKey:character1];
    NSInteger char1XValue = [[char1Coordinate substringWithRange:NSMakeRange(0, 1)] integerValue];
    NSInteger char1YValue = [[char1Coordinate substringWithRange:NSMakeRange(1, 1)] integerValue];
    NSString *char2Coordinate = [self.keyCoordinates objectForKey:character2];
    NSInteger char2XValue = [[char2Coordinate substringWithRange:NSMakeRange(0, 1)] integerValue];
    NSInteger char2YValue = [[char2Coordinate substringWithRange:NSMakeRange(1, 1)] integerValue];
    double y = char2YValue-char1YValue;
    double x = char2XValue-char1XValue;
    double distance = sqrt((pow(x,2)) - (pow(y,2)));
    characterDistanceSum += distance;
    return characterDistanceSum;
}
@end
