//
//  MerchantAccountType.m
//  MobileMerchant
//
//  Created by Rajesh T on 3/7/13.
//
//

#import "MerchantAccountType.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation MerchantAccountType

@synthesize marketType;
@synthesize deviceType;

+ (MerchantAccountType *) merchantAccount {
	MerchantAccountType *m = [[MerchantAccountType alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.marketType = nil;
		self.deviceType = nil;
	}
	return self;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MerchantAccount.marketType = %@\n"
						"MerchantContact.deviceType = %@\n",
						self.marketType,
						self.deviceType];
	return output;
}

+ (MerchantAccountType *) buildMerchantAccount:(GDataXMLElement *)element {
	GDataXMLElement *currNode;
	MerchantAccountType *m = [MerchantAccountType merchantAccount];
	
	NSArray *currArray = [element elementsForName:@"merchantAccount"];
	currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
	
	m.marketType = [NSString stringValueOfXMLElement:currNode withName:@"marketType"];
	m.deviceType = [NSString stringValueOfXMLElement:currNode withName:@"deviceType"];
	
	NSLog(@"MerchantAccount = %@", m);
	
	return m;
}

@end
