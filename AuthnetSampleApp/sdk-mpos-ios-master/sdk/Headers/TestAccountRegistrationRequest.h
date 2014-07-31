//
//  TestAccountRegistrationRequest.h
//  Anet SDK
//
//  Created by Shankar Gosain on 12/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"
#import "MobileDeviceType.h"

@interface TestAccountRegistrationRequest : AuthNetRequest{
    NSString *fullName;
    NSString *emailAddress;
    NSString *zipCode;
    NSString *loginName;
    NSString *password;
    NSString *captchaImageView;
    NSString *captchaUserInput;
    
	MobileDeviceType *mobileDevice;
}

@property (nonatomic, strong) MobileDeviceType *mobileDevice;

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *captchaImageView;
@property (nonatomic, strong) NSString *captchaUserInput;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TestAccountRegistrationRequest *) testAccountRegistrationRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;


@end
