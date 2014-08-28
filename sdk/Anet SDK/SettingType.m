//
//  SettingType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "SettingType.h"
#import "NSString+stringWithXMLTag.h"

@interface SettingType (private)
- (BOOL) isValidName;
@end


@implementation SettingType

@synthesize name;
@synthesize value;

+ (SettingType *) settingType {
	SettingType *t = [[SettingType alloc] init];
	return t;
}

- (BOOL) isValid {
	
	if (![self isValidName])
		return NO;
	
	return YES;
}

- (BOOL) isValidName {
	BOOL valid = NO;
	if ([self.name isEqualToString:@"allowPartialAuth"])
		valid = YES;

	if ([self.name isEqualToString:@"duplicateWindow"])
		valid = YES;

	if ([self.name isEqualToString:@"emailCustomer"])
		valid = YES;
	
	if ([self.name isEqualToString:@"recurringBilling"])
		valid = YES;
	
	if ([self.name isEqualToString:@"testRequest"])
		valid = YES;
	
	if ([self.name isEqualToString:@"headerEmailReceipt"])
		valid = YES;
	
	if ([self.name isEqualToString:@"footerEmailReceipt"])
		valid = YES;

	if ([self.name isEqualToString:@"merchantEmail"])
		valid = YES;

	return valid;
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
				   @"<setting>" 
						@"%@" 
						@"%@"
				   @"</setting>",
				   [NSString stringWithXMLTag:@"settingName" andValue:self.name],
				   [NSString stringWithXMLTag:@"settingValue" andValue:self.value]];
	
	return s;
}


- (NSString *) description {
	NSString *s = [NSString stringWithFormat:@""
				   "TransactionSetting.name = %@\n"
				   "TransactionSetting.value = %@",
				   self.name,
				   self.value];
	return s;
}

@end
