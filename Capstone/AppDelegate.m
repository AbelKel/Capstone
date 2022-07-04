//
//  AppDelegate.m
//  Capstone
//
//  Created by Abel Kelbessa on 7/3/22.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AccountViewController.h"
#import <Parse/Parse.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        configuration.applicationId = @"yNV6eCpUSvO10cLResalKCkP3CzxFFITH4738ogN";
        configuration.clientKey = @"txAhsUcgAxF6UqkOnhhHM5x8MAooRxEzxGh5k858";
        configuration.server = @"https://parseapi.back4app.com";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        AccountViewController *accountViewController = [[AccountViewController alloc]initWithNibName:@"AccountViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
       // self.window.rootViewController = navController;
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.window.rootViewController = loginViewController;
    }

    //[self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)applicaiton:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                    sourceApplication:sourceApplication annotation:annotation
    ];
    return handled;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
