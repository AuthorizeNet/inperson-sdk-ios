//
//  GetTransactionListRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in the reporting API getTransactionListRequest transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required the transaction.
 */
@interface GetTransactionListRequest : AuthNetRequest {
    NSString *batchId;
}

@property (nonatomic, strong) NSString *batchId;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (GetTransactionListRequest *) getTransactionListRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
