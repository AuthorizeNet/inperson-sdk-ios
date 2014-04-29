//
//  Messages.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/17/11.
//  Copyright 2011 none. All rights reserved.
//

#import "Messages.h"

#import "AuthNetMessage.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation Messages

@synthesize resultCode;
@synthesize messageArray;

+ (Messages *) messages {
	Messages *m = [[Messages alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.resultCode = nil;
		self.messageArray = [NSMutableArray array];
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"Messages.resultCode = %@\n"
						"Messages.message = %@\n",
						self.resultCode,
						self.messageArray];
	return output;
}

+ (Messages *) buildMessages:(GDataXMLElement *)element {
	GDataXMLElement *currNode;
	Messages *m = [Messages messages];
	
    NSLog(@"Elements: \n%@", element);
    
	NSArray *currArray = [element elementsForName:@"messages"];
	currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
	
	m.resultCode = [NSString stringValueOfXMLElement:currNode withName:@"resultCode"];
	
	
	currArray = [currNode elementsForName:@"message"];
	for (GDataXMLElement *node in currArray) {
		AuthNetMessage *message = [AuthNetMessage buildMessage:node];
		[m.messageArray addObject:message];
	}
	// debugging 
	NSLog(@"Messages: \n%@", m);
	
	return m;
}



+ (Messages *) buildMessagesForCaptchaResponse:(GDataXMLElement *)element {
	Messages *m = [Messages messages];
	    
    NSArray *partyMembers = [element elementsForName:@"s:Body"];
    for (GDataXMLElement *partyMember in partyMembers) {        
        NSArray *CaptchaResponse = [partyMember elementsForName:@"CaptchaResponse"];
        for (GDataXMLElement *CaptchaResponseMember in CaptchaResponse) {            
            NSArray *Response = [CaptchaResponseMember elementsForName:@"Response"];
            for (GDataXMLElement *ResponseMember in Response) {
                NSArray *captcha = [ResponseMember elementsForName:@"a:Messages"];
                for (GDataXMLElement *messageMember in captcha) {
                    NSArray *imagHash = [messageMember elementsForName:@"a:Status"];
                    for (GDataXMLElement *statusMember in imagHash) {
                        GDataXMLElement *status = (GDataXMLElement *) [imagHash objectAtIndex:0];
                        m.resultCode = status.stringValue;
                    }
                }
            }
        }
    }
	return m;
}


+ (Messages *) buildMessagesForTestAccountRegistrationResponse:(GDataXMLElement *)element {
	Messages *m = [Messages messages];
    
    NSArray *partyMembers = [element elementsForName:@"s:Body"];
    for (GDataXMLElement *partyMember in partyMembers) {
        NSArray *CaptchaResponse = [partyMember elementsForName:@"CaptchaResponse"];
        for (GDataXMLElement *CaptchaResponseMember in CaptchaResponse) {
            NSArray *Response = [CaptchaResponseMember elementsForName:@"Response"];
            for (GDataXMLElement *ResponseMember in Response) {
                NSArray *captcha = [ResponseMember elementsForName:@"a:Messages"];
                for (GDataXMLElement *messageMember in captcha) {
                    NSArray *imagHash = [messageMember elementsForName:@"a:Status"];
                    for (GDataXMLElement *statusMember in imagHash) {
                        GDataXMLElement *status = (GDataXMLElement *) [imagHash objectAtIndex:0];
                        m.resultCode = status.stringValue;
                    }
                }
            }
        }
    }
	return m;
}


@end
