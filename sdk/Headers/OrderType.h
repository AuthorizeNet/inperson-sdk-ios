//
//  Order.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

#define MAX_INVOICE_NUMBER_LENGTH 20
#define MAX_DESCRIPTION_LENGTH 255
#define MAX_ORDER_ITEM_SIZE 30

/**
 * Order. Contains the values that are common to the
 * order information of a  object.  Includes
 * an array of OrderItem for itemized orders.
 */
@interface OrderType : NSObject {
	NSString *invoiceNumber;
	NSString *orderDescription;
}

@property (nonatomic, strong) NSString *invoiceNumber;
@property (nonatomic, strong) NSString *orderDescription;

/**
 * Creates an autoreleased Order object;
 * @return Order an autoreleased Order object.
 */
+ (OrderType *) order;
/**
 * Validate that fields are valid in terms of length and acceptable values.
 * @return BOOL returns whether values are valid.
 */
- (BOOL) isValid;
/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
/**
 * OrderType from parsing the XML response indexed by GDataXMLElement
 * @return OrderType autorelease instance of the parser generated object.
 */
+ (OrderType *)buildOrder:(GDataXMLElement *)element;
@end
