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
+ (void)textToTranslate:(NSString *)description forText:(void(^)(NSString *text, NSError *error))completion {
       [Translate translate:description translatedText:^(NSString * _Nonnull text, NSError * _Nonnull error) {
          completion(text, nil);
       }];
}

+ (void)translate:(NSString *)text translatedText:(void(^)(NSString *text, NSError *error))completion {
    MLKTranslateLanguage initalLanguage;
    MLKTranslateLanguage changeLanguage;
    PFUser *currentUser = [PFUser currentUser];
    if ([currentUser[@"Language"] isEqual:@"English"]) {
        initalLanguage = MLKTranslateLanguageEnglish;
    }
    
    if ([currentUser[@"newLanguage"] isEqual:@"English"]) {
        changeLanguage = MLKTranslateLanguageEnglish;
    } else if ([currentUser[@"newLanguage"] isEqual:@"German"]) {
        changeLanguage = MLKTranslateLanguageGerman;
    } else if ([currentUser[@"newLanguage"] isEqual:@"Spanish"]) {
        changeLanguage = MLKTranslateLanguageSpanish;
    } else if ([currentUser[@"newLanguage"] isEqual:@"Arabic"]) {
        changeLanguage = MLKTranslateLanguageArabic;
    }
   MLKTranslatorOptions *options =
           [[MLKTranslatorOptions alloc] initWithSourceLanguage:initalLanguage
                                                 targetLanguage:changeLanguage];
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
                   };
               
             }];
         }
       }];
}
@end







