//
//  UserField.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "UserField.h"
#import "NSString+stringWithXMLTag.h"

@interface UserField (private)
- (BOOL) isValidName;
@end

@implementation UserField

@synthesize name;
@synthesize value;

+ (UserField *) userField {
	UserField *u = [[UserField alloc] init];
	return u;
}

- (id) init {
	self = [super init];
	
	if (self) {
		self.name = nil;
		self.value = nil;
	}
	
	return self;
}


- (NSString *) stringOfXMLRequest 
{
	
	NSString *s = [NSString stringWithFormat:@""
				   @"<userField>" 
						@"%@" 
						@"%@"
				   @"</userField>",
				   [NSString stringWithXMLTag:@"name" andValue:self.name],
				   [NSString stringWithXMLTag:@"value" andValue:self.value]];
	
	return s;
}


- (NSString *) description {
	NSString *s = [NSString stringWithFormat:@""
				   "UserField.name = %@\n"
				   "UserField.value = %@",
				   self.name,
				   self.value];
	return s;
}
@end
