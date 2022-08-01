//
//  Translate.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/31/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Translate : NSObject

+ (instancetype)shared;
- (void)textToTranslate:(NSString *)description;
+ (NSString *)returnMyWord;
@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
