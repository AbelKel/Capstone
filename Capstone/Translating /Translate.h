//
//  Translate.h
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import <Foundation/Foundation.h>
@import MLKit;

NS_ASSUME_NONNULL_BEGIN

@interface Translate : NSObject 

+ (void)textToTranslate:(NSString *)description forText:(void(^)(NSString *text, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
