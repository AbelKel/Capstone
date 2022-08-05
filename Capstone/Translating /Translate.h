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

+ (void)textToTranslate:(NSString *)inputText translatedTextBlock:(void(^)(NSString *text))textBlock;

@end

NS_ASSUME_NONNULL_END
