//
//  Translate.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/31/22.
//

#import "Translate.h"
#import "DetailsViewController.h"
@import MLKit;

@implementation Translate

+ (instancetype)shared {
    static Translate *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)textToTranslate:(NSString *)description {
    [Translate translate:description translatedText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
    }];
}

+ (NSString *)returnMyWord:(NSString *)word {
    return word;
}

+ (void)translate:(NSString *)text translatedText:(void(^)(NSString *text, NSError *error))completion {
    __block bool flag;
    MLKTranslatorOptions *options =
            [[MLKTranslatorOptions alloc] initWithSourceLanguage:MLKTranslateLanguageEnglish
                                                  targetLanguage:MLKTranslateLanguageGerman];
    MLKTranslator *englishGermanTranslator =
            [MLKTranslator translatorWithOptions:options];
    MLKModelDownloadConditions *conditions =
        [[MLKModelDownloadConditions alloc] initWithAllowsCellularAccess:NO
                                             allowsBackgroundDownloading:YES];
    [englishGermanTranslator downloadModelIfNeededWithConditions:conditions
                                                      completion:^(NSError *_Nullable error) {
      if (error != nil) {
        return;
      } else {
          flag = true;
      }
    }];
    if (flag) {
        [englishGermanTranslator translateText:text completion:^(NSString *_Nullable translatedText, NSError *_Nullable error) {
          if (error != nil || translatedText == nil) {
            return;
          } else {
//                completion(translatedText, nil);
              [Translate returnMyWord:translatedText];
          }
        }];
    }
}
@end
