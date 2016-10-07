//
//  MobileDeviceLoginResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "MerchantContactType.h"
#import "PermissionType.h"
#import "MerchantAccountType.h"

/**
 * Response object that has pointers to each of the different objects
 * required in a MobileDeviceLoginResponse transaction.
 * NOTE: Consult Authorize.Net Guide for the minimal fields required for each transaction type.
 */
@interface MobileDeviceLoginResponse : AuthNetResponse {
	NSString *sessionToken;
	MerchantContactType *merchantContact;
	NSMutableArray *userPermissions;
    MerchantAccountType *merchantAccount;
}

@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) MerchantContactType *merchantContact;
@property (nonatomic, strong) NSMutableArray *userPermissions;
@property (nonatomic, strong) MerchantAccountType *merchantAccount;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MobileDeviceLoginResponse *) mobileDeviceLoginResponse;

- (void) addPermission:(PermissionType *)p;

/**
 * Class method that takes in NSData and returns a fully parsed
 * MobileDeviceLoginResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed MobileDeviceLoginResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (MobileDeviceLoginResponse *)parseMobileDeviceLoginResponse:(NSData *)xmlData;

// For unit testing.
+ (MobileDeviceLoginResponse *)loadMobileDeviceLoginResponseFromFilename:(NSString *)filename;
@end
