//
//  MerchantAuthentication.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FingerPrintObjectType.h"



@interface MerchantAuthenticationType : NSObject {

	NSString *name;
	NSString *transactionKey;
	NSString *sessionToken;
	NSString *password;
	NSString *mobileDeviceId;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *transactionKey;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *mobileDeviceId;
@property (nonatomic, strong) FingerPrintObjectType *fingerPrint;


/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MerchantAuthenticationType *) merchantAuthentication;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
