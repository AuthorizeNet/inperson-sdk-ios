//
//  LineItemType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import "LineItemType.h"
#import "AuthNet.h"
#import "NSString+stringValueOfXMLElement.h"
#import "NSString+stringWithXMLTag.h"

@implementation LineItemType

@synthesize itemID;
@synthesize itemName;
@synthesize itemDescription;
@synthesize itemQuantity;
@synthesize itemPrice;
@synthesize itemTaxable;

+(LineItemType *) lineItem {
	LineItemType *l = [[LineItemType alloc] init];
	return l;
}

- (BOOL) isValid
{
	if (self.itemID != nil && self.itemID.length > MAX_ITEM_ID_LENGTH) {
		return NO;
	}
	
	if (self.itemName != nil && self.itemName.length > MAX_ITEM_NAME_LENGTH) {
		return NO;
	}
	
	if (self.itemDescription != nil && self.itemDescription.length > MAX_ITEM_DESCRIPTION_LENGTH) {
		return NO;
	}
	return YES;
}

- (BOOL) isValid:(NSError *)error
{
	return YES;
}

- (id) init
{
	self = [super init];

	if (self) {
		itemID = nil;
		itemName = nil;
		itemDescription = nil;
		itemQuantity = nil;
		itemPrice = nil;
		itemTaxable = NO;
	}
	
	return self;
}

- (NSString *) stringOfXMLRequest 
{
    NSString *taxableValue;
    
    if (self.itemTaxable) {
        taxableValue = @"true";
    }
    else {
        taxableValue = @"false";
    }
    
	NSString *s = [NSString stringWithFormat:@""
				   @"<lineItem>" 
						@"%@" 
						@"%@"
						@"%@"
						@"%@"
						@"%@"
                        @"%@"
				   @"</lineItem>",
				   [NSString stringWithXMLTag:@"itemId" andValue:self.itemID],
				   [NSString stringWithXMLTag:@"name" andValue:self.itemName],
				   [NSString stringWithXMLTag:@"description" andValue:self.itemDescription],
				   [NSString stringWithXMLTag:@"quantity" andValue:self.itemQuantity],
				   [NSString stringWithXMLTag:@"unitPrice" andValue:self.itemPrice],
                   [NSString stringWithXMLTag:@"taxable" andValue:taxableValue]];
	
	return s;
}


- (NSString *) description {
	
	NSMutableString *output = [NSString stringWithFormat:@""
							   "LineItem.itemID = %@\n"
							   "LineItem.itemName = %@\n"
							   "LineItem.itemDescription = %@\n"
							   "LineItem.itemQuantity = %@\n"
							   "LineItem.itemPrice = %@\n"
							   "LineItem.itemTaxable = %i\n",
							   self.itemID,
							   self.itemName,
							   self.itemDescription,
							   self.itemQuantity,
							   self.itemPrice,
							   self.itemTaxable];
	return output;
}


+ (LineItemType* )buildLineItem:(GDataXMLElement *)element {
	LineItemType *l = [LineItemType lineItem];
	l.itemID = [NSString stringValueOfXMLElement:element withName:@"itemId"];
	l.itemName = [NSString stringValueOfXMLElement:element withName:@"name"];
	l.itemDescription = [NSString stringValueOfXMLElement:element withName:@"description"];
	l.itemQuantity = [NSString stringValueOfXMLElement:element withName:@"quantity"];
	l.itemPrice = [NSString stringValueOfXMLElement:element withName:@"unitPrice"];
	NSString *value = [NSString stringValueOfXMLElement:element withName:@"taxable"];
    
	if ([value isEqualToString:@"true"])
		l.itemTaxable = YES;
	else
		l.itemTaxable = NO;
    
	//Debug
	NSLog(@"LineItem: \n%@", l);
	return l;
}
@end
