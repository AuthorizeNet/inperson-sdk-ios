//
//  LogoutResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"

/**
 * Response object that has pointers to each of the different objects
 * required in a logout transaction.
 * NOTE: Consult Authorize.Net Guide for the minimal fields required for each transaction type.
 */
@interface LogoutResponse : AuthNetResponse {
    NSString *captchaImage;
}

@property (nonatomic, strong) NSString *captchaImage;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (LogoutResponse *) logoutResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * LogoutResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed LogoutResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (LogoutResponse *)parseLogoutResponse:(NSData *)xmlData;

// For unit testing.
+ (LogoutResponse *)loadLogoutResponseFromFilename:(NSString *)filename;

+ (LogoutResponse *)parseTestAccountCaptchaResponse:(NSData *)xmlData;

@end
