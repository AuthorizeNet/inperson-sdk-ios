//
//  CustomerAddressType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/22/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NameAndAddressType.h"


@interface CustomerAddressType : NameAndAddressType {
    NSString *phoneNumber;
    NSString *faxNumber;
}

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *faxNumber;

/**
 * Creates an autoreleased CustomerAddressType object;
 * @return CustomerAddressType an autoreleased CustomerAddressType object.
 */
+ (CustomerAddressType *) customerAddressType;
/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

/**
 * CustomerAddressType from parsing the XML response indexed by GDataXMLElement
 * @return CustomerDataType autorelease instance of the parser generated object.
 */
+ (CustomerAddressType *)buildCustomerAddressType:(GDataXMLElement *)element;
@end
