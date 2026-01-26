//
//  GetUnsettledTransactionListRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in the reporting API getUnsettledTransactionListRequest transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required the transaction.
 */
@interface GetUnsettledTransactionListRequest : AuthNetRequest {
}

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (GetUnsettledTransactionListRequest *) getUnsettledTransactionListRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
