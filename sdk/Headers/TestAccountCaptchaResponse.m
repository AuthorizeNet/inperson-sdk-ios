//
//  TestAccountCaptchaResponse.m
//  Anet SDK
//
//  Created by Shankar Gosain on 09/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TestAccountCaptchaResponse.h"
#import "GDataXMLNode.h"
#import "NSString+dataFromFilename.h"
#import "NSString+stringValueOfXMLElement.h"

@interface TestAccountCaptchaResponse (private)

@end

@implementation TestAccountCaptchaResponse

@synthesize captchaImage;
@synthesize captchaView;

+ (TestAccountCaptchaResponse *) testAccountCaptchaResponse {
	TestAccountCaptchaResponse *m = [[TestAccountCaptchaResponse alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.captchaImage = nil;
    }
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"TestAccountCaptchaResponse.anetApiResponse = %@\n",
						self.anetApiResponse];
	return output;
}

+ (TestAccountCaptchaResponse *)parseTestAccountCaptchaResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0
															 error:&error];
	
    if (doc == nil) { return nil; }
	
	TestAccountCaptchaResponse *m = [TestAccountCaptchaResponse testAccountCaptchaResponse];

       m.anetApiResponse = [ANetApiResponse buildANetApiResponseForCaptcha:doc.rootElement];
        
        NSArray *partyMembers = [doc.rootElement elementsForName:@"s:Body"];
        for (GDataXMLElement *partyMember in partyMembers) {
    
            NSArray *CaptchaResponse = [partyMember elementsForName:@"CaptchaResponse"];
            for (GDataXMLElement *CaptchaResponseMember in CaptchaResponse) {
                NSLog(@"CaptchaResponse ####");
                
                NSArray *Response = [CaptchaResponseMember elementsForName:@"Response"];
                for (GDataXMLElement *ResponseMember in Response) {
                    
                     NSLog(@"Response ####");
                 
                    NSArray *captcha = [ResponseMember elementsForName:@"a:Captcha"];
                    for (GDataXMLElement *captchaMember in captcha) {
                        
                         NSLog(@"a:Captcha ####");
                        
                        NSArray *imagHash = [captchaMember elementsForName:@"a:Imagehash"];
                        for (GDataXMLElement *imagHashMember in imagHash) {
                            
                             NSLog(@"a:Imagehash ####");
                            
                            NSArray *imageString = [imagHashMember elementsForName:@"a:Image"];
                            NSLog(@"a:Image ####");
                            if (imageString.count > 0) {
                                
                                 NSLog(@"a:Image ####");
                                GDataXMLElement *firstName = (GDataXMLElement *) [imageString objectAtIndex:0];
                                 NSLog(@"IMAGE #### %@",firstName.stringValue);
                                m.captchaImage = firstName.stringValue;
                            }
                            
                            NSArray *imageView = [imagHashMember elementsForName:@"a:View"];
                            NSLog(@"a:View ####");
                            if (imageView.count > 0) {
                                
                                NSLog(@"imageView ####");
                                
                                GDataXMLElement *view = (GDataXMLElement *) [imageView objectAtIndex:0];
                                NSLog(@"IMAGE #### %@",view.stringValue);
                                m.captchaView = view.stringValue;
                            }
                        }
                    }
                }
            }
            
        
    }
       
	
    return m;
}

+ (TestAccountCaptchaResponse *)loadMobileDeviceLoginResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    TestAccountCaptchaResponse *m = [self parseTestAccountCaptchaResponse:xmlData];
	
	return m;
}



@end
