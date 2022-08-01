//
//  Translate.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Translate : NSObject

+ (NSString *)textToTranslate:(NSString *)description;
+ (void)translate:(NSString *)text translatedText:(void(^)(NSString *text, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
