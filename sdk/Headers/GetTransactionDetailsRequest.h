//
//  GetTransactionDetailsRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/3/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"
#import "GDataXMLNode.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in the reporting API transactionDetailsRequest transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required the transaction.
 */
@interface GetTransactionDetailsRequest : AuthNetRequest {
	NSString *transId;
}

@property (nonatomic, strong) NSString *transId;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
+ (GetTransactionDetailsRequest *) getTransactionDetailsRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
