//
//  CustomerDataType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import "CustomerDataType.h"
#import "NSString+stringWithXMLTag.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation CustomerDataType

@synthesize type;
@synthesize email;
@synthesize customerID;
@synthesize driversLicense;
@synthesize taxId;

+ (CustomerDataType *) customerDataType {
	CustomerDataType *c = [[CustomerDataType alloc] init];
	return c;
}

- (BOOL) isValid
{
	if (self.email != nil && self.email.length > MAX_EMAIL_LENGTH) {
		return NO;
	}
	
	if (self.customerID != nil && self.customerID.length > MAX_CUSTOMER_ID_LENGTH) {
		return NO;
	}
	return YES;
}

- (id) init {
	self = [super init];
	
	if (self) {
		self.type = nil;
		self.email = nil;
		self.customerID = nil;
        self.driversLicense = nil;
        self.taxId = nil;
	}
	
	return self;
}

- (NSString *) stringOfXMLRequest 
{
	NSString *s = [NSString stringWithFormat:@""
				   @"<customer>"
                        @"%@"
                        @"%@"
                        @"%@"
                        @"%@"
                        @"%@"
				   @"</customer>",
                   [NSString stringWithXMLTag:@"type" andValue:self.type],
                   [NSString stringWithXMLTag:@"id" andValue:self.customerID],
                   [NSString stringWithXMLTag:@"email" andValue:self.email],
                   [NSString stringWithXMLTag:@"driversLicense" andValue:self.driversLicense],
                   [NSString stringWithXMLTag:@"taxId" andValue:self.taxId]];

	return s;
}

- (NSString *) description {
	NSString * output = [NSString stringWithFormat:@""
						 "CustomerDataType.type = %@\n"
						 "CustomerDataType.customerId = %@\n"
						 "CustomerDataType.email = %@"
						 "CustomerDataType.driversLicense = %@"
						 "CustomerDataType.taxId = %@",
						 self.type,
						 self.customerID,
						 self.email,
                         self.driversLicense,
                         self.taxId];
	return output;
}


+ (CustomerDataType *)buildCustomerDataType:(GDataXMLElement *)element {
	CustomerDataType *c = [CustomerDataType customerDataType];
	
	c.type = [NSString stringValueOfXMLElement:element withName:@"type"];
	c.customerID = [NSString stringValueOfXMLElement:element withName:@"customerId"];
	c.email = [NSString stringValueOfXMLElement:element withName:@"email"];
	c.driversLicense = [NSString stringValueOfXMLElement:element withName:@"driversLicense"];
	c.taxId = [NSString stringValueOfXMLElement:element withName:@"taxId"];
	
	//Debugging
	NSLog(@"CustomerDataType = %@", c);
	
	return c;
}
@end
