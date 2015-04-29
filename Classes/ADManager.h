//
//  ADManager.h
//  Askt
//
//  Created by Jun Wang on 5/27/14.
//  Copyright (c) 2014 Whyse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) BOOL optout;

@property (nonatomic) NSUInteger displayAdPerTimes;

@property (nonatomic,strong) NSString* adUnitID;


- (void)displayInterstitialAD;

- (void)viewDisplayed;

@end
