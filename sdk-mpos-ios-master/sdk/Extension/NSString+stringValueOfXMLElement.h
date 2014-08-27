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
 * @param element The GDataXMLElement in the response data that will be search
 * for a particular XML child element.
 * @param elementName The name of the XML child element to parse for.
 */
@interface NSString (stringValueOfXMLElement)

+ (NSString *)stringValueOfXMLElement:(GDataXMLElement *)element withName:(NSString *) elementName;

@end
