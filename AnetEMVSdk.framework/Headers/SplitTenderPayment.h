//
//  SplitTenderPayment.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface SplitTenderPayment : NSObject {

	NSString *transId;
	NSString *responseCode;
	NSString *responseToCustomer;
	NSString *authCode;
	NSString *accountNumber;
	NSString *accountType;
	NSString *requestedAmount;
	NSString *approvedAmount;
	NSString *balanceOnCard;
}

@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseToCustomer;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *requestedAmount;
@property (nonatomic, strong) NSString *approvedAmount;
@property (nonatomic, strong) NSString *balanceOnCard;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (SplitTenderPayment *) splitTenderPayment;

/**
 * SplitTenderPayment from parsing the XML response indexed by GDataXMLElement
 * @return SplitTenderPayment autorelease instance of the parser generated object.
 */
+ (SplitTenderPayment *)buildSplitTenderPayment:(GDataXMLElement *)element;
@end
