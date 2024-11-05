//
//  TestAccountCaptchaResponse.h
//  Anet SDK
//
//  Created by Tejus Chavan on 09/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"

@interface TestAccountCaptchaResponse : AuthNetResponse {
	NSString *captchaImage;
    NSString *captchaView;
	
}

@property (nonatomic, strong) NSString *captchaImage;
@property (nonatomic, strong) NSString *captchaView;

+ (TestAccountCaptchaResponse *) testAccountCaptchaResponse;
+ (TestAccountCaptchaResponse *)loadMobileDeviceLoginResponseFromFilename:(NSString *)filename;
+ (TestAccountCaptchaResponse *)parseTestAccountCaptchaResponse:(NSData *)xmlData;
@end
