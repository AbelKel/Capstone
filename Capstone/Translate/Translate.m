//  Translation.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/28/22.
//

#import "Translate.h"
@import MLKit;

@implementation Translate

+ (void)translateText:(NSString *)inputText {
    __block NSString *translatedText;
    [Translate translate:inputText translatedText:^(NSString *text, NSError *error) {
        translatedText = text;
    }];
}

+ (void)translate:(NSString *)text translatedText:(void(^)(NSString *text, NSError *error))completion {
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
          [englishGermanTranslator translateText:text completion:^(NSString *_Nullable translatedText, NSError *_Nullable error) {
            if (error != nil || translatedText == nil) {
              return;
            } else {
                completion(translatedText, nil);
            }
          }];
      }
    }];
}
@end
