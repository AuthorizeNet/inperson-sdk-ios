//
//  TestAccountRegistrationResponse.m
//  Anet SDK
//
//  Created by Shankar Gosain on 12/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TestAccountRegistrationResponse.h"
#import "GDataXMLNode.h"
#import "NSString+dataFromFilename.h"


@implementation TestAccountRegistrationResponse

@synthesize registrationResponseMsg;

+ (TestAccountRegistrationResponse *) testAccountRegistrationResponse {
	TestAccountRegistrationResponse *m = [[TestAccountRegistrationResponse alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
	}
	return self;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"TestAccountRegistrationResponse.anetApiResponse = %@\n",
						self.anetApiResponse];
	return output;
}


+ (TestAccountRegistrationResponse *)parseTsetAccountRegistrationResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0
															 error:&error];
	
	NSLog(@"Error ======== %@", error);
	
    if (doc == nil) { return nil; }
	
	TestAccountRegistrationResponse *m = [TestAccountRegistrationResponse testAccountRegistrationResponse];
	/**
     *type:1 name:s:Body xml:"<s:Body><CreateMerchantResponse xmlns="http://visa.com/mobileApi"><Response xmlns:a="http://mobileApi.schema" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Messages><a:Status>OK</a:Status><a:Details><a:Code>E00101</a:Code><a:Text>Account Creation failed, please validate merchant data. - </a:Text></a:Details></a:Messages><a:ApiLoginID>-</a:ApiLoginID><a:ApiKey>-</a:ApiKey><a:LogonType>Manual</a:LogonType></Response></CreateMerchantResponse></s:Body>"}
     
     */
    m.anetApiResponse = [ANetApiResponse buildANetApiResponseTestAccountregistration:doc.rootElement];
    
    NSArray *partyMembers = [doc.rootElement elementsForName:@"s:Body"];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        NSArray *createMerchantResponse = [partyMember elementsForName:@"CreateMerchantResponse"];
        for (GDataXMLElement *merchantResponseMember in createMerchantResponse) {
            NSArray *Response = [merchantResponseMember elementsForName:@"Response"];
            for (GDataXMLElement *ResponseMember in Response) {
                NSArray *responseMessages = [ResponseMember elementsForName:@"a:Messages"];
                for (GDataXMLElement *responseMessagesMember in responseMessages) {
                    
                    NSArray *detailMessage = [responseMessagesMember elementsForName:@"a:Details"];
                    for (GDataXMLElement *detailMessageMember in detailMessage) {
                        NSArray *successMsgText = [detailMessageMember elementsForName:@"a:Text"];
                        if (successMsgText.count > 0) {
                            
                            GDataXMLElement *msgText = (GDataXMLElement *) [successMsgText objectAtIndex:0];
                            m.registrationResponseMsg = msgText.stringValue;
                        }
                    }
                }
            }
        }
    }
	NSLog(@"TestAccountRegistrationResponse: %@", m);
	
    return m;
}


// For unit testing.
+ (TestAccountRegistrationResponse *)loadTestAccountRegistrationResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    TestAccountRegistrationResponse *m = [self parseTsetAccountRegistrationResponse:xmlData];
	
	return m;
}


@end
