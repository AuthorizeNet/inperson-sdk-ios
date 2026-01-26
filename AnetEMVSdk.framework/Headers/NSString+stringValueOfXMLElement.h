//
//  NSString+stringValueOfXMLElement.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

/**
 * Method extension that returns the value in an XML block by 
 * querying the GDataXMLElement with tag elements of value passed
 * in by the variable elementName.
 */
@interface NSString (stringValueOfXMLElement)

+ (NSString *)stringValueOfXMLElement:(GDataXMLElement *)element withName:(NSString *) elementName;

@end
