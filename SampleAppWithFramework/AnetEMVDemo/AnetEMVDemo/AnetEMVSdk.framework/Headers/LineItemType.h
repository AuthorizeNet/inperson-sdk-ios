//
//  LineItemType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

#define MAX_ITEM_ID_LENGTH 31
#define MAX_ITEM_NAME_LENGTH 31
#define MAX_ITEM_DESCRIPTION_LENGTH 255
/**
 * LineItemType. Contains the values that are common to the
 * itemized order information of a  object.
 * NOTE: Please check AIM API XML Guide for valid
 * values for each field.  All fields are required.
 * Authorize.Net Gateway will return an error if any of
 * the field is missing.
 */
@interface LineItemType : NSObject {
	
	NSString *itemID;
	NSString *itemName;
	NSString *itemDescription;
	NSString *itemQuantity;
	NSString *itemPrice;
	BOOL itemTaxable;
}

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString *itemQuantity;
@property (nonatomic, strong) NSString *itemPrice;
@property (nonatomic) BOOL itemTaxable;

/**
 * Creates an autoreleased LineItemType object;
 * @return LineItemType an autoreleased LineItemType object.
 */
+ (LineItemType *) lineItem;
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
 * LineItemType from parsing the XML response indexed by GDataXMLElement
 * @return LineItemType autorelease instance of the parser generated object.
 */
+ (LineItemType* )buildLineItem:(GDataXMLElement *)element;

@end
