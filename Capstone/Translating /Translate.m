//
//  Translate.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/1/22.
//
#import "Translate.h"
#import "DetailsViewController.h"
@import MLKit;

@implementation Translate
+ (void)textToTranslate:(NSString *)inputText translatedTextBlock:(void(^)(NSString *text))textBlock {
   [Translate translate:inputText translatedText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           textBlock(text);
       });
   }];
}

+ (void)translate:(NSString *)text translatedText:(void(^)(NSString *text, NSError *error))completion {
    MLKTranslateLanguage initalLanguage = MLKTranslateLanguageEnglish;
    MLKTranslateLanguage changeLanguage = MLKTranslateLanguageEnglish;
    
    typedef enum {
        ENGLISH = 0,
        GERMAN,
        SPANISH,
        ARABIC
    } LanguageEnum;
    
    LanguageEnum selectedLanguage = ENGLISH;
    PFUser *currentUser = [PFUser currentUser];
    NSString *languageSelected = currentUser[@"newLanguage"];
    
    if ([languageSelected isEqual:@"English"]) {
        selectedLanguage = ((LanguageEnum)0);
    } else if ([languageSelected isEqual:@"German"]) {
        selectedLanguage = ((LanguageEnum)1);
    } else if ([languageSelected isEqual:@"Spanish"]) {
        selectedLanguage = ((LanguageEnum)2);
    } else if ([languageSelected isEqual:@"Arabic"]){
        selectedLanguage = ((LanguageEnum)3);
    }
    
    switch(selectedLanguage) {
        case ENGLISH:
            changeLanguage = MLKTranslateLanguageEnglish;
            break;
        case GERMAN:
            changeLanguage = MLKTranslateLanguageGerman;
            break;
        case SPANISH:
            changeLanguage = MLKTranslateLanguageSpanish;
            break;
        case ARABIC:
            changeLanguage = MLKTranslateLanguageArabic;
            break;
    }

   MLKTranslatorOptions *options =
           [[MLKTranslatorOptions alloc] initWithSourceLanguage:initalLanguage
                                                 targetLanguage:changeLanguage];
   MLKTranslator *translator =
           [MLKTranslator translatorWithOptions:options];
   MLKModelDownloadConditions *conditions =
       [[MLKModelDownloadConditions alloc] initWithAllowsCellularAccess:NO
                                            allowsBackgroundDownloading:YES];
       [translator downloadModelIfNeededWithConditions:conditions
                                                         completion:^(NSError *_Nullable error) {
         if (error != nil) {
           return;
         } else {
             [translator translateText:text completion:^(NSString *_Nullable translatedText, NSError *_Nullable error) {
               if (error != nil || translatedText == nil) {
                 return;
               } else {
                      completion(translatedText, nil);
               };
             }];
         }
       }];
}
@end
