//
//  ADManager.m
//  Askt
//
//  Created by Jun Wang on 5/27/14.
//  Copyright (c) 2014 Whyse. All rights reserved.
//

#import "ADManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

/// Enum of the different statuses resulting from processing a purchase.
typedef NS_ENUM(NSInteger, ADManagerStatus) {
    ADManagerStatusNone,
    ADManagerStatusRequestInProgress,
    ADManagerStatusRequested,
};

@interface ADManager()<GADInterstitialDelegate>

@property (nonatomic) NSUInteger viewDisplayedCount;
@property (nonatomic, strong) GADInterstitial *interstitial;

@property (nonatomic) ADManagerStatus status;
@property (nonatomic) BOOL displayAdImmediately;

@end

@implementation ADManager

#define KShowAd 50

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static ADManager* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.displayAdPerTimes = KShowAd;
    });
    return sharedInstance;
}


- (void)loadAdInMainThread{
    if (self.status == ADManagerStatusNone) {
        // Instantiate the interstitial using the class convenience method.
        self.interstitial = [[GADInterstitial alloc] init];
        self.interstitial.adUnitID = self.adUnitID;
        self.interstitial.delegate = self;
        [self.interstitial loadRequest:[GADRequest request]];
    }

    self.viewDisplayedCount += 1;
    if (self.viewDisplayedCount >= self.displayAdPerTimes) {
        [self showAD];
    }

}

- (void)viewDisplayed{
    NSLog(@"Count: %lu",(unsigned long)self.viewDisplayedCount);
    
    if (self.optout) {
        return;
    }
    
    [self performSelectorOnMainThread:@selector(loadAdInMainThread)
                           withObject:nil
                        waitUntilDone:NO];
    
}

- (void)displayInterstitialAD{
    self.displayAdImmediately = YES;
    [self viewDisplayed];
}

- (void)showAD{
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (self.status == ADManagerStatusRequested && !keyWindow.rootViewController.presentedViewController) {
        [self.interstitial presentFromRootViewController:keyWindow.rootViewController];
        
        self.status = ADManagerStatusNone;
        self.viewDisplayedCount = 1;
    }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    self.status = ADManagerStatusRequested;
    
    if (self.displayAdImmediately) {
        self.displayAdImmediately = NO;
        [self showAD];
    }
}

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    self.status = ADManagerStatusNone;
}

@end
