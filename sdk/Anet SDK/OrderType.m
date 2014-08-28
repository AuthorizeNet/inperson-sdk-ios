//
//  Order.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import "OrderType.h"
#import "NSString+stringWithXMLTag.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation OrderType

@synthesize invoiceNumber;
@synthesize orderDescription;

+ (OrderType *) order {
	OrderType *o = [[OrderType alloc] init];
	return o;
}

- (BOOL) isValid
{
	if (self.invoiceNumber != nil && self.invoiceNumber.length > MAX_INVOICE_NUMBER_LENGTH) {
		return NO;
	}
	
	if (self.orderDescription != nil && self.orderDescription.length > MAX_DESCRIPTION_LENGTH) {
		return NO;
	}
	
	return YES;
}

- (id) init
{
	self = [super init];
	
	if (self) {
		invoiceNumber = nil;
		orderDescription = nil;
	}
	
	return self;
}

- (NSString *) stringOfXMLRequest 
{
    
    NSString *s = [NSString stringWithFormat:@""
                   @"<order>"
                        @"%@"       //invoiceNumber
                        @"%@"       //description
                   @"</order>",
                   [NSString stringWithXMLTag:@"invoiceNumber" andValue:self.invoiceNumber],
                   [NSString stringWithXMLTag:@"description" andValue:self.orderDescription]];
    return s;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"Order.invoiceNumber = %@\n"
						"Order.orderDescription = %@\n",
						self.invoiceNumber,
						self.orderDescription];
	
	return output;
}



+ (OrderType *)buildOrder:(GDataXMLElement *)element {
	OrderType *o = [OrderType order];
	
	o.invoiceNumber = [NSString stringValueOfXMLElement:element withName:@"invoiceNumber"];
	o.orderDescription = [NSString stringValueOfXMLElement:element withName:@"description"];
    //	o.purchaseOrderNumber = [NSString stringValueOfXMLElement:element withName:@"purchaseOrderNumber"];
    
	//Debug
	NSLog(@"Order: \n%@", o);
    
	return o;
}

@end
