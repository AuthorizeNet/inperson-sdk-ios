//
//  NSString+stringValueOfXMLElement.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSString+stringValueOfXMLElement.h"


@implementation NSString (stringValueOfXMLElement)

+ (NSString *)stringValueOfXMLElement:(GDataXMLElement *)element withName:(NSString *) elementName {
	NSArray *currArray;
	GDataXMLElement *currNode;
	currArray = [element elementsForName:elementName];
	
	if (currArray.count > 0) {
		currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
		return currNode.stringValue;
	}
	return nil;
}
@end
