//
//  CustomerDataType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
/**
 * Customer related information
 */

#define MAX_EMAIL_LENGTH 255
#define MAX_CUSTOMER_ID_LENGTH 20

/**
 * Customer. Contains the values that are common to the
 * customer information of a  object.
 */
@interface CustomerDataType : NSObject {
	NSString *type;
	NSString *email;
	NSString *customerID;
    NSString *driversLicense;
    NSString *taxId;
}

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *driversLicense;
@property (nonatomic, strong) NSString *taxId;

/**
 * Creates an autoreleased Customer object;
 * @return Customer an autoreleased Customer object.
 */
+ (CustomerDataType *) customerDataType;
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
 * CustomerDataType from parsing the XML response indexed by GDataXMLElement
 * @return CustomerDataType autorelease instance of the parser generated object.
 */
+ (CustomerDataType *)buildCustomerDataType:(GDataXMLElement *)element;

@end
