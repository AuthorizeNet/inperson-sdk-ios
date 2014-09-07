//
//  ViewController.m
//  AuthnetLab
//
//  Created by Shankar Gosain on 07/23/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "ViewController.h"
#import "AuthNet.h"


#define INFORMATION_MESSAGE @"The application utilizes the Authorize.Net SDK avaliable on GitHub under the username AurhorizedNet. Authorize.Net is a wholly owned subsidiary of Visa."

#define ERROR_MESSAGE @"Login error Please check your login details or your device is not registered."


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) //iOS >=5.0
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bar.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bar_landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        
    }
    
    [AuthNet authNetWithEnvironment:ENV_TEST];
    
     NSLog(@"View Controller : viewDidLoad");
    
    [_loginButton.layer setCornerRadius:5.0f];
    [_loginTextView.layer setCornerRadius:5.0f];
    [_paswordTextView.layer setCornerRadius:5.0f];
    
    _loginFieldEmptyImage.hidden = YES;
    _passwordFieldEmptyImage.hidden = YES;
    
   // [self loginToGateway];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"View Controller : textFieldShouldReturn");
    
    if(textField == _loginTextView){
        [_loginTextView resignFirstResponder];
        [_paswordTextView becomeFirstResponder];
    }else if(textField == _paswordTextView){
        [_paswordTextView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"View Controller : shouldChangeCharactersInRange");
    
    if(textField == _loginTextView && string.length != 0){
        _loginFieldEmptyImage.hidden = YES;
    }else if(textField == _paswordTextView && string.length != 0){
        _passwordFieldEmptyImage.hidden = YES;
    }
    
    return YES;
}

- (void) loginToGateway {

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
    _activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [_activityIndicator startAnimating];
    
    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];

    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = @"358347040811237";
   
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = _loginTextView.text;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = _paswordTextView.text;
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
}

// MOBILE DELEGATE METHODS
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response{
    NSLog(@"ViewController : mobileDeviceLoginSucceeded - %@",response);
    _sessionToken = response.sessionToken;
    [_activityIndicator stopAnimating];
    
    CreditCardViewController *creditCardView = (CreditCardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"creditCardView"];
    creditCardView.sessionToken = _sessionToken;
    [self presentModalViewController:creditCardView animated:YES];
}


/**
 * Optional delegate: method is called when a non is CreateTransactionResponse is returned from the server.
 * The errorType data member of response should indicate TRANSACTION_ERROR or SERVER_ERROR.
 * TRANSACTION_ERROR are non-APRROVED response code.  SERVER_ERROR are due to non
 * non gateway responses.  Typically these are non successful HTTP responses.  The actual
 * HTTP response is returned in the AuthNetResponse object's responseReasonText instance variable.
 */
- (void) requestFailed:(AuthNetResponse *)response{
    NSLog(@"ViewController : requestFailed - %@",response);
    [_activityIndicator stopAnimating];
    
    UIAlertView *infoAlertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:INFORMATION_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlertView show];
    
}


/**
 * Optional delegate: method is called when a connection error occurs while connecting to the server..
 * The errorType data member of response should indicate CONNECTION_ERROR.  More detail
 * may be included in the AuthNetResponse object's responseReasonText.
 */
- (void) connectionFailed:(AuthNetResponse *)response{
    NSLog(@"ViewController : connectionFailed - %@",response);
}

- (void) paymentSucceeded:(CreateTransactionResponse *) response {
    NSLog(@"Payment succeeded");
    // Handle payment success
}

- (void)dealloc {
}

- (IBAction)onClickLoginAction:(id)sender {
    
     NSLog(@"View Controller : onClickLoginAction");
    
    if(_loginTextView.text.length == 0){
        _loginFieldEmptyImage.hidden = NO;
    }else if (_paswordTextView.text.length == 0){
        _passwordFieldEmptyImage.hidden = NO;
    }else if(_loginTextView.text.length != 0 && _paswordTextView.text.length != 0){
        [self loginToGateway];
    }
}

- (IBAction)onClickInfoButton:(id)sender {
    
     NSLog(@"View Controller : onClickInfoButton");
    
    UIAlertView *infoAlertView = [[UIAlertView alloc] initWithTitle:@"Developer Information" message:INFORMATION_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlertView show];
                                  
    
}
@end
