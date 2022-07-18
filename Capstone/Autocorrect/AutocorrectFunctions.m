//
//  AutocorrectFunctions.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/14/22.
//
#import "AutocorrectFunctions.h"
#include "math.h"
#import "College.h"

@implementation AutocorrectFunctions

+ (NSString *)findCorrectWord:(NSString *)searchWord forCollegesInArray:(NSArray *)colleges {
    AutocorrectFunctions *myAutocorrectFunctions = [[AutocorrectFunctions alloc] init];
    double minDifferenceBetweenWords = 1000;
    NSString *correctWord;
    for (College *college in colleges) {
        double hammingDistanceFullCollegeName = [myAutocorrectFunctions hammingDistanceCalculator:searchWord secondWordToCompareOutOfTwoWords:college.name];
        if (hammingDistanceFullCollegeName < minDifferenceBetweenWords) {
            if (hammingDistanceFullCollegeName < minDifferenceBetweenWords) {
                minDifferenceBetweenWords = hammingDistanceFullCollegeName;
            }
            correctWord = college.name;
        }
    }
    return correctWord;
}

/*
 This function helps map each key on the keyboard to a specific coordinate. It helps the HammingDistance calculaor calculate the distance between each characters of the two words.
 The lesser the distance, the more closer the two character are. Based on this assumption, if two characters are really close to each other, then there is a higher chance of making a typo.
 */
- (void)createCoordinates {
    self.keyCoordinates = [[NSMutableDictionary alloc] init];
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

/*
 This function takes in two strings and passes them on to hammingDistanceHelper method to calcualte the distance between each chatacter in the two words.
 */
- (double)hammingDistanceCalculator:(NSString *)firstWordToCompareOutOfTwoWords secondWordToCompareOutOfTwoWords:(NSString *)secondWordToCompareOutOfTwoWords {
    [self createCoordinates];
    double sum = 0;
    NSString *character1;
    NSString *character2;
    int lengthOfFirstWord = firstWordToCompareOutOfTwoWords.length;
    int lengthOfSecondWord = secondWordToCompareOutOfTwoWords.length;
    if (lengthOfFirstWord == lengthOfSecondWord) {
        for (int i = 0; i < [firstWordToCompareOutOfTwoWords length]; i++) {
            character1 = [firstWordToCompareOutOfTwoWords substringWithRange:NSMakeRange(i, 1)];
            character2 = [secondWordToCompareOutOfTwoWords substringWithRange:NSMakeRange(i, 1)];
            sum += [self hammingDistanceHelper:character1 characterFromTheSecondWord:character2];
        }
    } else if (lengthOfFirstWord > lengthOfSecondWord) {
            for (int i = 0; i < [secondWordToCompareOutOfTwoWords length]; i++) {
                character1 = [firstWordToCompareOutOfTwoWords substringWithRange:NSMakeRange(i, 1)];
                character2 = [secondWordToCompareOutOfTwoWords substringWithRange:NSMakeRange(i, 1)];
                sum += [self hammingDistanceHelper:character1 characterFromTheSecondWord:character2];
        }
        sum += (lengthOfFirstWord - lengthOfSecondWord)*10;
    } else {
        for (int i = 0; i < [firstWordToCompareOutOfTwoWords length]; i++) {
            character1 = [firstWordToCompareOutOfTwoWords substringWithRange:NSMakeRange(i, 1)];
            character2 = [secondWordToCompareOutOfTwoWords substringWithRange:NSMakeRange(i, 1)];
            sum += [self hammingDistanceHelper:character1 characterFromTheSecondWord:character2];
      }
        sum += (lengthOfSecondWord-lengthOfFirstWord)*10;
    }
    return sum;
}

/*
 Calculates the distance between two characters on a keyboard.
 */
- (double)hammingDistanceHelper:(NSString *)characterFromTheFirstWord characterFromTheSecondWord:(NSString *)characterFromTheSecondWord {
    double characterDistanceSum = 0;
    NSString *char1Coordinate = [self.keyCoordinates objectForKey:[characterFromTheFirstWord lowercaseString]];
    NSInteger char1XValue = [[char1Coordinate substringWithRange:NSMakeRange(0, 1)] integerValue];
    NSInteger char1YValue = [[char1Coordinate substringWithRange:NSMakeRange(1, 1)] integerValue];
    NSString *char2Coordinate = [self.keyCoordinates objectForKey:[characterFromTheSecondWord lowercaseString]];
    NSInteger char2XValue = [[char2Coordinate substringWithRange:NSMakeRange(0, 1)] integerValue];
    NSInteger char2YValue = [[char2Coordinate substringWithRange:NSMakeRange(1, 1)] integerValue];
    double y = char2YValue-char1YValue;
    double x = char2XValue-char1XValue;
    double distance = sqrt((pow(x,2)) + (pow(y,2)));
    characterDistanceSum += distance;
    return characterDistanceSum;
}
@end
