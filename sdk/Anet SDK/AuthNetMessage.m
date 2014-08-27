//
//  Message.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/18/11.
//  Copyright 2011 none. All rights reserved.
//

#import "AuthNetMessage.h"
#import "NSString+stringValueOfXMLElement.h"


@implementation AuthNetMessage

@synthesize code;
@synthesize text;
@synthesize mDescription;

+ (AuthNetMessage *) message {
	AuthNetMessage *m = [[AuthNetMessage alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.code = nil;
		self.text = nil;
		self.mDescription = nil;
	}
	return self;
}



- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"Message.code = %@\n"
						"Message.text = %@\n"
						"Message.description = %@\n",
						self.code,
						self.text,
						self.mDescription];
	return output;
}



+ (AuthNetMessage *)buildMessage:(GDataXMLElement *)element {
	
	AuthNetMessage *m = [AuthNetMessage message];
	
	m.code = [NSString stringValueOfXMLElement:element withName:@"code"];
	m.text = [NSString stringValueOfXMLElement:element withName:@"text"];
	m.mDescription = [NSString stringValueOfXMLElement:element withName:@"description"];
	
	// debugging 
	NSLog(@"Message: \n%@", m);
	
	return m;
}

@end
