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
+ (NSString *)textToTranslate:(NSString *)description {
    __block NSString *myTranslatedText;
    [Translate translate:description translatedText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
        myTranslatedText = text;
    }];
    return myTranslatedText;
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
              dispatch_async(dispatch_get_main_queue(), ^{
                 completion(translatedText, nil);
              });
          }
        }];
    }
}
@end
