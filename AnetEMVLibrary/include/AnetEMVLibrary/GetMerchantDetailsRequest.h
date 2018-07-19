//
//  getMerchantDetailsRequest.h
//  AnetEMVSdk
//
//  Created by Taneja, Pankaj on 7/5/17.
//  Copyright © 2017 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

@interface GetMerchantDetailsRequest : AuthNetRequest

+ (GetMerchantDetailsRequest *) getMerchantDetailsRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
