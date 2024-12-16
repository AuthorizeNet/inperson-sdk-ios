//
//  ANetApiRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantAuthenticationType.h"

@interface ANetApiRequest : NSObject {
	MerchantAuthenticationType *merchantAuthentication;
	NSString *refId;
    NSString *clientID;
}

@property (nonatomic, strong) MerchantAuthenticationType *merchantAuthentication;
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) NSString *clientID;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (ANetApiRequest *) anetApiRequest;

- (NSString *) getClientID;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

- (NSString *) stringOfXMLRequestForTransaction;     //For Transactions

@end
