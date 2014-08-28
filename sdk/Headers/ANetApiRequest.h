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
}

@property (nonatomic, strong) MerchantAuthenticationType *merchantAuthentication;
@property (nonatomic, strong) NSString *refId;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (ANetApiRequest *) anetApiRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
