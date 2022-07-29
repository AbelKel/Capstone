//
//  Translation.h
//  Capstone
//
//  Created by Abel Kelbessa on 7/28/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Translation : NSObject

+ (void)translate:(NSString *)text translatedText:(void(^)(NSString *text, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
