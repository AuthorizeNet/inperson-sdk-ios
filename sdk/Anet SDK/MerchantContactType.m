//
//  MerchantContactType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MerchantContactType.h"
#import "NSString+stringValueOfXMLElement.h"


@implementation MerchantContactType

@synthesize merchantName;
@synthesize merchantAddress;
@synthesize merchantCity;
@synthesize merchantState;
@synthesize merchantZip;
@synthesize merchantPhone;

+ (MerchantContactType *) merchantContact {
	MerchantContactType *m = [[MerchantContactType alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.merchantName = nil;
		self.merchantAddress = nil;
		self.merchantCity = nil;
		self.merchantState = nil;
		self.merchantZip = nil;
		self.merchantPhone = nil;
	}
	return self;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MerchantContact.merchantName = %@\n"
						"MerchantContact.merchantAddress = %@\n"
						"MerchantContact.merchantCity = %@\n"
						"MerchantContact.merchantState = %@\n"
						"MerchantContact.merchantZip = %@\n"
						"MerchantContact.merchantPhone = %@\n",
						self.merchantName,
						self.merchantAddress,
						self.merchantState,
						self.merchantState,
						self.merchantZip,
						self.merchantPhone];
	return output;
}


+ (MerchantContactType *) buildMerchantContact:(GDataXMLElement *)element {
	GDataXMLElement *currNode;
	MerchantContactType *m = [MerchantContactType merchantContact];
	
	NSArray *currArray = [element elementsForName:@"merchantContact"];
	currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
	
	m.merchantName = [NSString stringValueOfXMLElement:currNode withName:@"merchantName"];
	m.merchantAddress = [NSString stringValueOfXMLElement:currNode withName:@"merchantAddress"];
	m.merchantCity = [NSString stringValueOfXMLElement:currNode withName:@"merchantCity"];
	m.merchantState = [NSString stringValueOfXMLElement:currNode withName:@"merchantState"];
	m.merchantZip = [NSString stringValueOfXMLElement:currNode withName:@"merchantZip"];
	m.merchantPhone = [NSString stringValueOfXMLElement:currNode withName:@"merchantPhone"];
	
	NSLog(@"MerchantContact = %@", m);
	
	return m;
}

@end
