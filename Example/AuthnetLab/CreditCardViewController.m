//
//  CreditCardViewController.m
//  AuthnetLab
//
//  Modified by Senthil Kumar Periyasamy on 10/20/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "CreditCardViewController.h"
#import "NSString+HMAC_MD5.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABRecord.h>

#define FLOAT_COLOR_VALUE(n) (n)/255.0

#define kCreditCardLength 16
#define kCreditCardLengthPlusSpaces (kCreditCardLength + 3)
#define kExpirationLength 4
#define kExpirationLengthPlusSlash  kExpirationLength + 1
#define kCVV2Length 4
#define kZipLength 5

#define kCreditCardObscureLength (kCreditCardLength - 4)

#define kSpace @" "
#define kSlash @"/"

#define kCardNumberErrorAlert 1001
#define kCardExpirationErrorAlert 1002

#define INFORMATION_MESSAGE @"The application utilizes the Authorize.Net SDK avaliable on GitHub under the username AurhorizeNet. Authorize.Net is a wholly owned subsidiary of Visa."
#define PAYMENT_SUCCESSFUL @"Your transaction of $0.01 has been processed successfully."

typedef enum AddressType {
    BILLIING,
    SHIPPING
} ADDRESSTYPE;

@interface CreditCardViewController(private)<DecimalKeypadViewDelegate,AuthNetDelegate,UITextFieldDelegate,UIAlertViewDelegate,PKPaymentAuthorizationViewControllerDelegate>
- (void) formatValue:(UITextField *)textField;
- (BOOL) isMaxLength:(UITextField *)textField;
- (void) validateCreditCardValue;

@end

@implementation CreditCardViewController


@synthesize creditCardTextField;
@synthesize expirationTextField;
@synthesize cvv2TextField;
@synthesize zipTextField;
@synthesize swipeNowButton;
@synthesize signAuthButton;
@synthesize currentField;
@synthesize creditCardBuf;
@synthesize expirationBuf;

@synthesize billingAddress,shippingAddress;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) //iOS >=5.0
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bar.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bar_landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        
    }
    
    
    [self initializeViews];
    [AuthNet authNetWithEnvironment:ENV_TEST];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    //Subscribe to this so that we can invalidate Swiper related tasks before the app goes to background state.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillGetBackGrounded) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self clearInputFields];
    [super viewWillAppear:YES];
    [self.keypad setCancelTransactionButton];
    
    [self.creditCardTextField becomeFirstResponder];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    // These were registered in viewDidLoad, so remove them here
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    creditCardTextField = nil;
    expirationTextField = nil;
    cvv2TextField = nil;
    zipTextField = nil;
    _keypad = nil;
}

- (void)initializeViews
{
    self.creditCardTextField.inputView = _keypad;
    self.expirationTextField.inputView = _keypad;
    self.cvv2TextField.inputView = _keypad;
    self.zipTextField.inputView = _keypad;
    
    NSString *buf = [self.creditCardTextField.text stringByReplacingOccurrencesOfString:kSpace withString:@""];
    if(buf==nil)
        buf=@"";
    self.creditCardBuf = [NSString stringWithString:buf];
    
    buf = [self.expirationTextField.text stringByReplacingOccurrencesOfString:kSlash withString:@""];
    if(buf==nil)
        buf=@"";
    self.expirationBuf = [NSString stringWithString:buf];
    
    //TODO:  REMOVE AFTER TESTING
    [self validateCreditCardValue];
}

-(void) LogoutAction{
    LogoutRequest *logoutRequest = [LogoutRequest logoutRequest];
    logoutRequest.anetApiRequest.merchantAuthentication.name = nil;
    logoutRequest.anetApiRequest.merchantAuthentication.password = nil;
    
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an LogoutRequest:logoutRequest];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearInputFields
{
    self.cvv2TextField.text = @"";
    self.zipTextField.text = @"";
    self.creditCardTextField.text = @"";
    self.expirationTextField.text = @"";
    
    // Clear the buffers too
    self.creditCardBuf = @"";
    self.expirationBuf = @"";
    
    [self.creditCardTextField resignFirstResponder];
    [self.expirationTextField resignFirstResponder];
    [self.cvv2TextField resignFirstResponder];
    [self.zipTextField resignFirstResponder];
}

- (NSString*)expirationDateWithoutSeparator
{
    return [self.expirationTextField.text stringByReplacingOccurrencesOfString:kSlash withString:@""];
}

- (void) formatValue:(UITextField *)textField {
    NSMutableString *value = [NSMutableString string];
    
    if (textField == self.creditCardTextField ) {
        NSInteger length = [self.creditCardBuf length];
        
        for (int i = 0; i < length; i++) {
            
            // Reveal only the last character.
            if (length <= kCreditCardObscureLength) {
                
                if (i == (length - 1)) {
                    [value appendString:[self.creditCardBuf substringWithRange:NSMakeRange(i,1)]];
                } else {
                    [value appendString:@"●"];
                }
            }
            // Reveal the last 4 characters
            else {
                
                if (i < kCreditCardObscureLength) {
                    [value appendString:@"●"];
                } else {
                    [value appendString:[self.creditCardBuf substringWithRange:NSMakeRange(i,1)]];
                }
            }
            
            //After 4 characters add a space
            if ((i +1) % 4 == 0 &&
                ([value length] < kCreditCardLengthPlusSpaces)) {
                [value appendString:kSpace];
            }
        }
        textField.text = value;
    }
    if (textField == self.expirationTextField) {
        for (int i = 0; i < [self.expirationBuf length]; i++) {
            [value appendString:[self.expirationBuf substringWithRange:NSMakeRange(i,1)]];
            
            // After two characters append a slash.
            if ((i + 1) % 2 == 0 &&
                ([value length] < kExpirationLengthPlusSlash)) {
                [value appendString:kSlash];
            }
        }
        textField.text = value;
    }
}



- (void) validateCreditCardValue {
    NSString *ccNum = self.creditCardBuf;
    
    // Use the Authorize.Net SDK to validate credit card number
    if (![CreditCardType isValidCreditCardNumber:ccNum]) {
        self.creditCardTextField.textColor = [UIColor redColor];
    } else {
        self.creditCardTextField.textColor = [UIColor colorWithRed:FLOAT_COLOR_VALUE(98) green:FLOAT_COLOR_VALUE(169) blue:FLOAT_COLOR_VALUE(40) alpha:1];
    }
}


- (BOOL) isMaxLength:(UITextField *)textField {
    
    if (textField == self.creditCardTextField && [textField.text length] >= kCreditCardLengthPlusSpaces) {
        return YES;
    }
    else if (textField == self.expirationTextField && [textField.text length] >= kExpirationLengthPlusSlash) {
        return YES;
    }
    else if (textField == self.cvv2TextField && [textField.text length] >= kCVV2Length) {
        return YES;
    }
    else if (textField == self.zipTextField && [textField.text length] >= kZipLength) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark DecimalKeypadViewDelegate
- (void)keypad:(DecimalKeypadView *)keypad keyPressed:(NSString *)string {
    
    if ([string isEqualToString:@"⌫"]) {
        string = @"";
    }
    
    if ([string isEqualToString:@"Cancel Transaction"]) {
        return;
    }
    // [self.view textField:[self.view currentField] shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:string];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentField = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.creditCardTextField) {
        if ([string length] > 0) { //NOT A BACK SPACE Add it
            
            if ([self isMaxLength:textField])
                return NO;
            
            self.creditCardBuf  = [NSString stringWithFormat:@"%@%@", self.creditCardBuf, string];
        } else {
            
            //Back Space do manual backspace
            if ([self.creditCardBuf length] > 1) {
                self.creditCardBuf = [self.creditCardBuf substringWithRange:NSMakeRange(0, [self.creditCardBuf length] - 1)];
            } else {
                self.creditCardBuf = @"";
            }
        }
        [self formatValue:textField];
        [self validateCreditCardValue];
    } else if (textField == self.expirationTextField) {
        if ([string length] > 0) { //NOT A BACK SPACE Add it
            
            if ([self isMaxLength:textField])
                return NO;
            
            self.expirationBuf  = [NSString stringWithFormat:@"%@%@", self.expirationBuf, string];
        } else {
            
            //Back Space do manual backspace
            if ([self.expirationBuf length] > 1) {
                self.expirationBuf = [self.expirationBuf substringWithRange:NSMakeRange(0, [self.expirationBuf length] - 1)];
                [self formatValue:textField];
            } else {
                self.expirationBuf = @"";
            }
        }
        
        [self formatValue:textField];
        
    } else if (textField == self.cvv2TextField) {
        if ([string length] > 0) {
            
            if ([self isMaxLength:textField])
                return NO;
            
            self.cvv2TextField.text = [NSString stringWithFormat:@"%@%@", self.cvv2TextField.text, string];
        }else {
            
            //Back Space do manual backspace
            if ([self.cvv2TextField.text length] > 1) {
                self.cvv2TextField.text = [self.cvv2TextField.text substringWithRange:NSMakeRange(0, [self.cvv2TextField.text length] - 1)];
            } else {
                self.cvv2TextField.text = @"";
            }
        }
    } else if (textField == self.zipTextField) {
        if ([string length] > 0) {
            
            if ([self isMaxLength:textField])
                return NO;
            
            self.zipTextField.text = [NSString stringWithFormat:@"%@%@", self.zipTextField.text, string];
        }else {
            
            //Back Space do manual backspace
            if ([self.zipTextField.text length] > 1) {
                self.zipTextField.text = [self.zipTextField.text substringWithRange:NSMakeRange(0, [self.zipTextField.text length] - 1)];
            } else {
                self.zipTextField.text = @"";
            }
        }
    }
    return NO;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.creditCardTextField) {
        self.creditCardBuf = [NSString string];
    }
    
    if (textField == self.expirationTextField) {
        self.expirationBuf = [NSString string];
    }
    return YES;
}

#pragma mark -
#pragma mark Private Method

- (void) saveCreditCardInfo {
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
    _activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [_activityIndicator startAnimating];
    
    
    AuthNet *an = [AuthNet getInstance];
    
    [an setDelegate:self];
    
    CreditCardType *c = [CreditCardType creditCardType];
    c.cardNumber = self.creditCardBuf;
    c.expirationDate = [self.expirationTextField.text stringByReplacingOccurrencesOfString:kSlash withString:@""];
    if ([self.cvv2TextField.text length]) {
        c.cardCode = [NSString stringWithString:self.cvv2TextField.text];
    }
    CustomerAddressType *b = [CustomerAddressType customerAddressType];
    
    if ([self.zipTextField.text length]) {
        b.zip = [NSString stringWithString:self.zipTextField.text];
    }
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = c;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Soda";
    lineItem.itemDescription = @"Soda";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"1.00";
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = @"20.00";
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    requestType.shipping = extendedAmountTypeShipping;
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = @"358347040811237";
    request.anetApiRequest.merchantAuthentication.sessionToken = _sessionToken;
    
    [an purchaseWithRequest:request];
    
}


- (void) keyboardWillShow:(NSNotification *)n {
    //    [UIView setAnimationsEnabled:NO];
}

- (void) keyboardWillHide:(NSNotification *)n {
    //	[UIView setAnimationsEnabled:YES];
}


#pragma mark -
#pragma mark - AuthNetDelegate Methods

- (void)paymentSucceeded:(CreateTransactionResponse*)response {
    [self clearInputFields];
    [_activityIndicator stopAnimating];
    
    NSLog(@"Payment Success ********************** ");
    
    NSString *title = @"Successfull Transaction";
    NSString *alertMsg = nil;
    UIAlertView *PaumentSuccess = nil;
    
    TransactionResponse *transResponse = response.transactionResponse;
    
    alertMsg = [response responseReasonText];
    NSLog(@"%@",response.responseReasonText);
    
    if ([transResponse.responseCode isEqualToString:@"4"])
    {
        PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"LOGOUT",nil];
    }
    else
    {
        PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:PAYMENT_SUCCESSFUL delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"LOGOUT",nil];
    }
    [PaumentSuccess show];
    
}

- (void)paymentCanceled {
    
    NSLog(@"Payment Canceled ********************** ");
    
    [_activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) requestFailed:(AuthNetResponse *)response {
    
    NSLog(@"Request Failed ********************** ");
    
    NSString *title = nil;
    NSString *alertErrorMsg = nil;
    UIAlertView *alert = nil;
    
    [_activityIndicator stopAnimating];
    
    if ( [response errorType] == SERVER_ERROR)
    {
        title = NSLocalizedString(@"Server Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    else if([response errorType] == TRANSACTION_ERROR)
    {
        title = NSLocalizedString(@"Transaction Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    else if([response errorType] == CONNECTION_ERROR)
    {
        title = NSLocalizedString(@"Connection Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    
    Messages *ma = response.anetApiResponse.messages;
    
    AuthNetMessage *m = [ma.messageArray objectAtIndex:0];
    
    NSLog(@"Response Msg Array Count: %lu", (unsigned long)[ma.messageArray count]);
    
    NSLog(@"Response Msg Code %@ ", m.code);
    
    NSString *errorCode = [NSString stringWithFormat:@"%@",m.code];
    NSString *errorText = [NSString stringWithFormat:@"%@",m.text];
    
    NSString *errorMsg = [NSString stringWithFormat:@"%@ : %@", errorCode, errorText];
    
    if (alertErrorMsg == nil) {
        alertErrorMsg = errorText;
    }
    
    NSLog(@"Error Code and Msg %@", errorMsg);
    
    
    if ( ([m.code isEqualToString:@"E00027"]) || ([m.code isEqualToString:@"E00007"]) || ([m.code isEqualToString:@"E00096"]))
    {
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:alertErrorMsg
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    else if ([m.code isEqualToString:@"E00008"]) // Finger Print Value is not valid.
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                           message:errorText
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:alertErrorMsg
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    [alert show];
    return;
}

- (void) connectionFailed:(AuthNetResponse *)response {
    NSLog(@"%@", response.responseReasonText);
    NSLog(@"Connection Failed");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if ([response errorType] == NO_CONNECTION_ERROR)
    {
        title = NSLocalizedString(@"No Signal", @"");
        message = NSLocalizedString(@"Unable to complete your request. No Internet connection.", @"");
    }
    else
    {
        title = NSLocalizedString(@"Connection Error", @"");
        message = NSLocalizedString(@"A connection error occurred.  Please try again.", @"");
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
    
}


-(void)logoutSucceeded:(LogoutResponse *)response{
    
    NSLog(@"Logout Success ********************** ");
    
}


#pragma mark -
#pragma mark UIAlertView Delegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self LogoutAction];
    }
}

#pragma mark -
#pragma mark IBAction

- (IBAction)onClickBarItemInfo:(id)sender {
    
    UIAlertView *infoAlertView = [[UIAlertView alloc] initWithTitle:@"Developer Information" message:INFORMATION_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlertView show];
}

- (IBAction)buyWithApplePayButtonPressed:(id)sender
{
    // ApplePay with Passkit
    [self presentPaymentController];
    
    
    // ApplePay demo without Passkit using fake FingerPrint and Blob
    //[self createTransactionWithOutPassKit];
}


- (IBAction)onClickLogoutPressed:(id)sender {
    [self LogoutAction];
}

- (IBAction) infoPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"The security code (CVV2) is a unique three or four-digit number on the back of a card (on the front for American Express).", @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    
    return;
}

- (IBAction) continuePressed {
    if (![self.creditCardBuf length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"A card number is required to continue.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardNumberErrorAlert];
        [alert show];
        
        return;
    }
    
    
    if (![CreditCardType isValidCreditCardNumber:self.creditCardBuf]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid card number.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardNumberErrorAlert];
        [alert show];
        
        return;
    }
    
    if (![self.expirationTextField.text length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"An expiration date is required to continue.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return;
    }
    
    if ([self.expirationBuf length] != EXPIRATION_DATE_LENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return;
    } else {
        // Validate
        NSArray *components = [[self.expirationTextField text] componentsSeparatedByString:@"/"];
        NSString *month = [components objectAtIndex:0];
        NSString *year = [components objectAtIndex:1];
        
        // Check to see if month is correct
        if ([month intValue] == 0 || [month intValue] > 12) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
            [alert setTag:kCardExpirationErrorAlert];
            [alert show];
            
            return;
        }
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDate *currentDate = [NSDate date];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"M/yyyy"];
        NSString *currentDateString = [dateFormat stringFromDate:currentDate];
        components = [currentDateString componentsSeparatedByString:@"/"];
        NSString *currentMonth = [components objectAtIndex:0];
        NSString *currentYear = [[components objectAtIndex:1] substringFromIndex:2];
        
        
        
        // Check if we are correct
        if ([year intValue] == [currentYear intValue]) {
            if ([month intValue] < [currentMonth intValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
                [alert setTag:kCardExpirationErrorAlert];
                [alert show];
                
                return;
            }
        } else if ([year intValue] < [currentYear intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
            [alert setTag:kCardExpirationErrorAlert];
            [alert show];
            
            return;
        }
    }
    
    [self saveCreditCardInfo];
    
}

- (IBAction)swipePressed
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
    _activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [_activityIndicator startAnimating];
    
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    
    SwiperDataType *st = [SwiperDataType swiperDataType];
    st.encryptedValue = @"02f700801f4725008383252a343736312a2a2a2a2a2a2a2a303031305e56495341204143515549524552205445535420434152442030355e313531322a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3f2a3b343736312a2a2a2a2a2a2a2a303031303d313531322a2a2a2a2a2a2a2a2a2a2a2a2a3f2aef80a083368880ae9515cdef8bb2ac7991d781a76f02939576605a6709762b6972b2be3a5b744f7dacffe1b276c18ba266040e749f717e2e80fdbe60164200fb056bcee846947adc9a7dd10c0a81be0c90b2674a61bbb6d3f3167170c97ed30ead1215ea1636fb8fd1e2e7e594c44aa95431323438303237373162994901000003e00181394903";
    st.deviceDescription = @"4649443d4944544543482e556e694d61672e416e64726f69642e53646b7631";
    st.encryptionType = @"TDES";
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.swiperData = st;
    
    TransRetailInfoType *retailInfo = [TransRetailInfoType transRetailInfoType];
    retailInfo.marketType = @"2";
    retailInfo.deviceType = @"7";
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Soda";
    lineItem.itemDescription = @"Soda";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"1.00";
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = @"20.00";
    requestType.tax = extendedAmountTypeTax;
    requestType.payment = paymentType;
    requestType.shipping = extendedAmountTypeShipping;
    requestType.retail = retailInfo;
    
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = @"358347040811237";
    request.anetApiRequest.merchantAuthentication.sessionToken = _sessionToken;
    
    [an purchaseWithRequest:request];
}

-(void) _applicationWillGetBackGrounded
{
}

-(void) _applicationWillEnterForeground
{
}

-(CreateTransactionRequest *)createTransactionReqObjectWithApiLoginID:(NSString *) apiLoginID
                                                  fingerPrintHashData:(NSString *) fpHashData
                                                       sequenceNumber:(NSInteger) sequenceNumber
                                                      transactionType:(AUTHNET_ACTION) transactionType
                                                      opaqueDataValue:(NSString*) opaqueDataValue
                                                       dataDescriptor:(NSString *) dataDescriptor
                                                        invoiceNumber:(NSString *) invoiceNumber
                                                          totalAmount:(NSDecimalNumber*) totalAmount
                                                          fpTimeStamp:(NSTimeInterval) fpTimeStamp
{
    // create the transaction.
    CreateTransactionRequest *transactionRequestObj = [CreateTransactionRequest createTransactionRequest];
    TransactionRequestType *transactionRequestType = [TransactionRequestType transactionRequest];
    
    transactionRequestObj.transactionRequest = transactionRequestType;
    transactionRequestObj.transactionType = transactionType;
    
    // Set the fingerprint.
    // Note: Finger print generation requires transaction key.
    // Finger print generation must happen on the server.
    
    FingerPrintObjectType *fpObject = [FingerPrintObjectType fingerPrintObjectType];
    fpObject.hashValue = fpHashData;
    fpObject.sequenceNumber= sequenceNumber;
    fpObject.timeStamp = fpTimeStamp;
    
    transactionRequestObj.anetApiRequest.merchantAuthentication.fingerPrint = fpObject;
    transactionRequestObj.anetApiRequest.merchantAuthentication.name = apiLoginID;
    
    // Set the Opaque data
    OpaqueDataType *opaqueData = [OpaqueDataType opaqueDataType];
    opaqueData.dataValue= opaqueDataValue;
    opaqueData.dataDescriptor = dataDescriptor;
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard= nil;
    paymentType.bankAccount= nil;
    paymentType.trackData= nil;
    paymentType.swiperData= nil;
    paymentType.opData = opaqueData;
    
    transactionRequestObj.transactionRequest.billTo.firstName = self.billingAddress.firstName;
    transactionRequestObj.transactionRequest.billTo.lastName = self.billingAddress.lastName;
    transactionRequestObj.transactionRequest.billTo.address = self.billingAddress.street1;
    transactionRequestObj.transactionRequest.billTo.city = self.billingAddress.city;
    transactionRequestObj.transactionRequest.billTo.zip = self.billingAddress.zip;
    transactionRequestObj.transactionRequest.billTo.state = self.billingAddress.state;
    transactionRequestObj.transactionRequest.billTo.country = self.billingAddress.country;
    transactionRequestObj.transactionRequest.billTo.phoneNumber = self.billingAddress.phone;
    
    
    transactionRequestObj.transactionRequest.shipTo.firstName = self.shippingAddress.firstName;
    transactionRequestObj.transactionRequest.shipTo.lastName = self.shippingAddress.lastName;
    transactionRequestObj.transactionRequest.shipTo.address = self.shippingAddress.street1;
    transactionRequestObj.transactionRequest.shipTo.city = self.shippingAddress.city;
    transactionRequestObj.transactionRequest.shipTo.zip = self.shippingAddress.zip;
    transactionRequestObj.transactionRequest.shipTo.state = self.shippingAddress.state;
    transactionRequestObj.transactionRequest.shipTo.country = self.shippingAddress.country;
    
    transactionRequestObj.transactionRequest.customer.email = self.shippingAddress.email;
    
    
    
    transactionRequestType.amount = [NSString stringWithFormat:@"%@",totalAmount];
    transactionRequestType.payment = paymentType;
    transactionRequestType.retail.marketType = @"0"; //0
    transactionRequestType.retail.deviceType = @"7";
    
    OrderType *orderType = [OrderType order];
    orderType.invoiceNumber = invoiceNumber;
    NSLog(@"Invoice Number Before Sending the Request %@", orderType.invoiceNumber);
    
    return transactionRequestObj;
}

// ApplePay demo without Passkit using fake FingerPrint and Blob
-(void) createTransactionWithOutPassKit
{
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // This part of the code that generates the finger print is present here only to make the sample app work.
    // Finger print generation should be done on the server.
    
    NSString *apiLogID                       = @"29XNx9w36";
    NSString *transactionSecretKey           = @"9fF3AVtw6jG8m27R";
    NSString *dataDescriptor                 = @"COMMON.APPLE.INAPP.PAYMENT";
    
    NSInteger sequenceNumber = arc4random() % 100;
    NSLog(@"Invoice Number [Random]: %ld", (long)sequenceNumber);
    
    
    NSNumber *aNumber = [NSNumber numberWithDouble:0.01];
    NSDecimalNumber *totalAmount = [NSDecimalNumber decimalNumberWithDecimal:[aNumber decimalValue]];
    NSLog(@"Total Amount: %@", totalAmount);
    
    //NSDecimalNumber* invoiceNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
    
    NSTimeInterval fingerprintTimestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *nFP = [self prepareFPHashValueWithApiLoginID:apiLogID
                                      transactionSecretKey:transactionSecretKey
                                            sequenceNumber:sequenceNumber
                                               totalAmount:totalAmount
                                                 timeStamp:fingerprintTimestamp];
    
    NSLog(@"Finger Print After New Method %@", nFP);
    
    CreateTransactionRequest *transactionRequestObj = [self createTransactionReqObjectWithApiLoginID:apiLogID
                                                                                 fingerPrintHashData:nFP
                                                                                      sequenceNumber:sequenceNumber
                                                                                     transactionType:AUTH_ONLY
                                                                                     opaqueDataValue:[self getData2]
                                                                                      dataDescriptor:dataDescriptor
                                                                                       invoiceNumber:[NSString stringWithFormat:@"%d", arc4random() % 100]
                                                                                         totalAmount:totalAmount
                                                                                         fpTimeStamp:fingerprintTimestamp];
    if (transactionRequestObj!= nil)
    {
        AuthNet *authNetSDK = [AuthNet getInstance];
        [authNetSDK setDelegate:self];
        
        // Submit the transaction.
        [authNetSDK purchaseWithRequest:transactionRequestObj];
        
        
    }
    
    
    
}


// note: this is a sample blob.


-(NSString* )getData2
{
    return @"eyJkYXRhIjoiVXIxZ2NESnczZDlEc0lkcDBuNlwvUmVSMENTQ3A0KzZNTUkxUlhwOVBjZkgzZDZVTDJtUnRJMGJCS09MMmNrVkluNXhPQkIwZmxUQkdEUmFGZGp2OTRPUklRVHdsM0VaWEI4cWxCZFl6UGQ1WFhNTU81MGVSR1NQTlwvUEdqeDA2WVRmMlhUMnI4ZzZZamZlSDdob3ZsNmR4Nk9JV1llM0NDSGhYSlFzSkpZWUpUb2RZZlp0b1BRKzd3VFBiR05Bbll0NElESk4xYkJDMXJSQnRrTHBvUE9ZUk1mWXRqSHVkYWVwOG9SbzZaWFRRVVBmdkVXdVY2S01EVzlKTzhsbjlUTE1Nak9PYVwvVXRQZ3JTeTA1WU42RE4xT1wvS2JyeisrY01CeHRlSjBuODg3U2JLZ3cyVUczSDI1UG96bkpocUNOMjlPNTVFZ2FoRlZ1NmszVHQ4aXNTK3dMT3pOa21xeFlrUytUWlEwT3RWWkU4XC84bWRUa3NLVTIwWXRBXC9yZ3p4cE94N2g1MkhTOXBiZ0ducXBSYnB0SWJBRUpITk4yZHRXQ25TUk9Zc0pjSW9YXC9zPSIsInZlcnNpb24iOiJFQ192MSIsImhlYWRlciI6eyJhcHBsaWNhdGlvbkRhdGEiOiI5NGVlMDU5MzM1ZTU4N2U1MDFjYzRiZjkwNjEzZTA4MTRmMDBhN2IwOGJjN2M2NDhmZDg2NWEyYWY2YTIyY2MyIiwidHJhbnNhY3Rpb25JZCI6ImMxY2FmNWFlNzJmMDAzOWE4MmJhZDkyYjgyODM2MzczNGY4NWJmMmY5Y2FkZjE5M2QxYmFkOWRkY2I2MGE3OTUiLCJlcGhlbWVyYWxQdWJsaWNLZXkiOiJNSUlCU3pDQ0FRTUdCeXFHU000OUFnRXdnZmNDQVFFd0xBWUhLb1pJemowQkFRSWhBUFwvXC9cL1wvOEFBQUFCQUFBQUFBQUFBQUFBQUFBQVwvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvTUZzRUlQXC9cL1wvXC84QUFBQUJBQUFBQUFBQUFBQUFBQUFBXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvOEJDQmF4alhZcWpxVDU3UHJ2VlYybUlhOFpSMEdzTXhUc1BZN3pqdytKOUpnU3dNVkFNU2ROZ2lHNXdTVGFtWjQ0Uk9kSnJlQm4zNlFCRUVFYXhmUjh1RXNRa2Y0dk9ibFk2UkE4bmNEZllFdDZ6T2c5S0U1UmRpWXdwWlA0MExpXC9ocFwvbTQ3bjYwcDhENTRXSzg0elYyc3hYczdMdGtCb043OVI5UUloQVBcL1wvXC9cLzhBQUFBQVwvXC9cL1wvXC9cL1wvXC9cL1wvKzg1dnF0cHhlZWhQTzV5c0w4WXlWUkFnRUJBMElBQk1jWk5BSDVtY2ZDVXdRT3JycDM1dkpJazBJMU92RXQrUkJaVFlmdFhiSXZjYjdYQzJnK3pMMkFzYWpcL3o2TWxJa0p0OVRPTVl2VVU4ZGJneE01S3gxbz0iLCJwdWJsaWNLZXlIYXNoIjoidDZtRHdrc3dqSEU3YnV0TWFCTmpZMGVzTDVtbGV4aFB6dHVcL3ppQWJCMWc9In0sInNpZ25hdHVyZSI6Ik1JSURRZ1lKS29aSWh2Y05BUWNDb0lJRE16Q0NBeThDQVFFeEN6QUpCZ1VyRGdNQ0dnVUFNQXNHQ1NxR1NJYjNEUUVIQWFDQ0Fpc3dnZ0luTUlJQmxLQURBZ0VDQWhCY2wrUGYzK1U0cGsxM25WRDlud1FRTUFrR0JTc09Bd0lkQlFBd0p6RWxNQ01HQTFVRUF4NGNBR01BYUFCdEFHRUFhUUJBQUhZQWFRQnpBR0VBTGdCakFHOEFiVEFlRncweE5EQXhNREV3TmpBd01EQmFGdzB5TkRBeE1ERXdOakF3TURCYU1DY3hKVEFqQmdOVkJBTWVIQUJqQUdnQWJRQmhBR2tBUUFCMkFHa0Fjd0JoQUM0QVl3QnZBRzB3Z1o4d0RRWUpLb1pJaHZjTkFRRUJCUUFEZ1kwQU1JR0pBb0dCQU5DOCtrZ3RnbXZXRjFPempnRE5yalRFQlJ1b1wvNU1LdmxNMTQ2cEFmN0d4NDFibEU5dzRmSVhKQUQ3RmZPN1FLaklYWU50MzlyTHl5N3hEd2JcLzVJa1pNNjBUWjJpSTFwajU1VWM4ZmQ0ZnpPcGszZnRaYVFHWE5MWXB0RzFkOVY3SVM4Mk91cDlNTW8xQlBWclhUUEhOY3NNOTlFUFVuUHFkYmVHYzg3bTByQWdNQkFBR2pYREJhTUZnR0ExVWRBUVJSTUUrQUVIWldQcld0SmQ3WVo0MzFoQ2c3WUZTaEtUQW5NU1V3SXdZRFZRUURIaHdBWXdCb0FHMEFZUUJwQUVBQWRnQnBBSE1BWVFBdUFHTUFid0J0Z2hCY2wrUGYzK1U0cGsxM25WRDlud1FRTUFrR0JTc09Bd0lkQlFBRGdZRUFiVUtZQ2t1SUtTOVFRMm1GY01ZUkVJbTJsK1hnOFwvSlh2K0dCVlFKa09Lb3NjWTRpTkRGQVwvYlFsb2dmOUxMVTg0VEh3TlJuc3ZWM1BydjdSVFk4MWdxMGR0Qzh6WWNBYUFrQ0hJSTN5cU1uSjRBT3U2RU9XOWtKazIzMmdTRTdXbEN0SGJmTFNLZnVTZ1FYOEtYUVl1WkxrMlJyNjNOOEFwWHNYd0JMM2NKMHhnZUF3Z2QwQ0FRRXdPekFuTVNVd0l3WURWUVFESGh3QVl3Qm9BRzBBWVFCcEFFQUFkZ0JwQUhNQVlRQXVBR01BYndCdEFoQmNsK1BmMytVNHBrMTNuVkQ5bndRUU1Ba0dCU3NPQXdJYUJRQXdEUVlKS29aSWh2Y05BUUVCQlFBRWdZQ29lMm5iTVhoRG9lUlVGTkJJd1lhUlwvVzYyXC9PMitrem1iSVM2VmVOTzRWWStXQlZYN0ZWMEVqMGtZYWM3QUViSFpKUzhMc2VCeTZjTFFMYzNESkM4WElpTXo1a3NhUEtraFBBbElFbWVZU3plWXdMOVNNOGptQW9KQ0VVakVHU1N2anVPSkh6WlJ3TjZxRHAyS0RPUVY0N3RlUFJyT3NzN3hxMld5dnJxeXlRPT0ifQ==";
}

// ApplyPay demo section

- (void) performTransactionWithEncryptedPaymentData: (NSString*) encryptedPaymentData withPaymentAmount: (NSString*) paymnetAmount
{
    
    NSDecimalNumber* amount = [NSDecimalNumber decimalNumberWithString:paymnetAmount];
    NSDecimalNumber* invoiceNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
    NSTimeInterval fingerprintTimestamp = [[NSDate date] timeIntervalSince1970];
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // Replace with Your Api log in ID and Transacation Secret Key.
    // This is a test merchant credentials to demo the capability, this would work with Visa cards only. Add a valid Visa card in the Passbook and make a sample transaction.
    
    NSString *apiLogInID                     = @"29XNx9w36";      // replace with YOUR_APILOGIN_ID
    NSString *transactionSecretKey           = @"9fF3AVtw6jG8m27R"; // replace with YOUR_TRANSACTION_SECRET_KEY
    
    
    NSString *dataDescriptor                 = @"FID=COMMON.APPLE.INAPP.PAYMENT";
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // This part of the code that generates the finger print is present here only to make the sample app work.
    // Finger print generation should be done on the server.
    
    NSString *fingerprintHashValue = [self prepareFPHashValueWithApiLoginID:apiLogInID
                                                       transactionSecretKey:transactionSecretKey
                                                             sequenceNumber:invoiceNumber.longValue
                                                                totalAmount:amount
                                                                  timeStamp:fingerprintTimestamp];
    
    CreateTransactionRequest * transactionRequestObj = [self createTransactionReqObjectWithApiLoginID:apiLogInID
                                                                                  fingerPrintHashData:fingerprintHashValue
                                                                                       sequenceNumber:invoiceNumber.intValue
                                                                                      transactionType:AUTH_ONLY
                                                                                      opaqueDataValue:encryptedPaymentData
                                                                                       dataDescriptor:dataDescriptor
                                                                                        invoiceNumber:invoiceNumber.stringValue
                                                                                          totalAmount:amount
                                                                                          fpTimeStamp:fingerprintTimestamp];
    if (transactionRequestObj != nil)
    {
        
        AuthNet *authNet = [AuthNet getInstance];
        [authNet setDelegate:self];
        
        authNet.environment = ENV_TEST;
        // Submit the transaction for AUTH_CAPTURE.
        [authNet purchaseWithRequest:transactionRequestObj];
        
        // Submit the transaction for AUTH_ONLY.
        //[authNet authorizeWithRequest:transactionRequestObj];
    }
    
    
}

/*
 Example Fingerprint Input Field Order
 "authnettest^789^67897654^10.50^"
 
 ----------WARNING!----------------
 Finger print generation requires the transaction key. This should
 be done at the server. It is shown here only for Demo purposes.
 http://www.authorize.net/support/DirectPost_guide.pdf p22-23
 */

-(NSString*) prepareFPHashValueWithApiLoginID:(NSString*) apiLoginID
                         transactionSecretKey:(NSString*) transactionSecretKey
                               sequenceNumber:(NSInteger) sequenceNumber
                                  totalAmount:(NSDecimalNumber*) totalAmount
                                    timeStamp:(NSTimeInterval) timeStamp
{
    NSString *fpHashValue = nil;
    
    fpHashValue =[NSString stringWithFormat:@"%@^%ld^%lld^%@^", apiLoginID, (long)sequenceNumber, (long long)timeStamp, totalAmount];
    
    
    NSLog(@"Finger Print Before HMAC_MD5: %@", fpHashValue);
    
    return [NSString HMAC_MD5_WithTransactionKey:transactionSecretKey fromValue:fpHashValue];
}


+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

-(void) updateAddressObject: (Address *)addressObj fromPKPaymentABRecord:(ABRecordRef *) PKPaymentABRecord
{
    if (PKPaymentABRecord != nil && addressObj != nil)
    {
        
        addressObj.firstName = (__bridge NSString*)ABRecordCopyValue(PKPaymentABRecord,kABPersonFirstNameProperty);
        addressObj.lastName = (__bridge NSString*)ABRecordCopyValue(PKPaymentABRecord, kABPersonLastNameProperty);
        
        ABMultiValueRef emails = (__bridge NSString*)ABRecordCopyValue(PKPaymentABRecord, kABPersonEmailProperty);
        
        if(ABMultiValueGetCount(emails) > 0 )
        {
            for(CFIndex i = 0; i< ABMultiValueGetCount(emails); i++ )
            {
                CFStringRef label = ABMultiValueCopyLabelAtIndex(emails, i);
                CFStringRef value = ABMultiValueCopyValueAtIndex(emails, i);
                addressObj.email = (__bridge NSString*)value;
                if (label) CFRelease(label);
                if (value) CFRelease(value);
            }
        }
        
        
        ABMultiValueRef phoneNumbers = (__bridge NSString*)ABRecordCopyValue(PKPaymentABRecord, kABPersonPhoneProperty);
        
        if(ABMultiValueGetCount(phoneNumbers) > 0 )
        {
            for(CFIndex i = 0; i< ABMultiValueGetCount(phoneNumbers); i++ )
            {
                CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
                CFStringRef value = ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                addressObj.phone = (__bridge NSString*)value;
                if (label) CFRelease(label);
                if (value) CFRelease(value);
            }
        }
        
        ABMultiValueRef streetAddress = ABRecordCopyValue(PKPaymentABRecord, kABPersonAddressProperty);
        if (ABMultiValueGetCount(streetAddress) > 0)
        {
            NSDictionary *theDict = (__bridge NSDictionary*)ABMultiValueCopyValueAtIndex(streetAddress, 0);
            
            addressObj.street1 = [theDict objectForKey:(NSString *)kABPersonAddressStreetKey];
            addressObj.city = [theDict objectForKey:(NSString *)kABPersonAddressCityKey];
            addressObj.state = [theDict objectForKey:(NSString *)kABPersonAddressStateKey];
            addressObj.zip = [theDict objectForKey:(NSString *)kABPersonAddressZIPKey];
            addressObj.country = [theDict objectForKey:(NSString *)kABPersonAddressCountryKey];
        }
        CFRelease(streetAddress);
    }
    else
    {
        NSLog(@"Invalid Params");
    }
}

// PassKit Delegate handlers

#pragma mark - Authorization delegate methods

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    if (payment)
    {
        // Go off and auth the card
        NSString *amount = @"0.01"; // Get the payment amount
        self.billingAddress = [[Address alloc] init ];
        self.shippingAddress = [[Address alloc] init ];
        
        if (payment.billingAddress != nil && self.billingAddress != nil)
        {
            [self updateAddressObject:self.billingAddress fromPKPaymentABRecord:(ABRecordRef*)payment.billingAddress];
            
        }
        
        if (payment.shippingAddress != nil && self.shippingAddress != nil)
        {
            [self updateAddressObject:self.shippingAddress fromPKPaymentABRecord:(ABRecordRef*)payment.shippingAddress];
            
        }
        
        // Since the Phone and Email is enabled only if we enable the Shipping, Just to use for the billing we do this.
        
        if (self.billingAddress.phone == nil)
        {
            self.billingAddress.phone = self.shippingAddress.phone;
        }
        
        if (self.billingAddress.email == nil)
        {
            self.billingAddress.email = self.shippingAddress.email;
        }
        
        NSString *base64string = [CreditCardViewController  base64forData:payment.token.paymentData];
        
        [self performTransactionWithEncryptedPaymentData:base64string withPaymentAmount:amount];
        
        completion(PKPaymentAuthorizationStatusSuccess);
    }
    else
    {
        completion(PKPaymentAuthorizationStatusFailure);
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    
}
// ApplePay with Passkit
-(void )presentPaymentController
{
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    request.currencyCode = @"USD";
    request.countryCode = @"US";
    // This is a test merchant id to demo the capability, this would work with Visa cards only.
    request.merchantIdentifier = @"merchant.anet.sampleapp.dev.001";  // replace with YOUR_APPLE_MERCHANT_ID
    request.applicationData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    request.merchantCapabilities = PKMerchantCapability3DS;
    request.supportedNetworks = @[PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkAmex];
    request.requiredBillingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldEmail;
    request.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldEmail;
    
    ///Set amount here
    NSString *amountText =  @"0.01"; // Get the payment amount
    NSDecimalNumber *amountValue = [NSDecimalNumber decimalNumberWithString:amountText];
    
    PKPaymentSummaryItem *item = [[PKPaymentSummaryItem alloc] init];
    item.amount = amountValue;
    //item.amount = [[NSDecimalNumber alloc] initWithInt:20];
    item.label = @"Test Payment Total";
    
    request.paymentSummaryItems = @[item];
    
    PKPaymentAuthorizationViewController *vc = nil;
    
    // need to setup correct entitlement to make the view to show
    @try
    {
        vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    }
    
    @catch (NSException *e)
    {
        NSLog(@"Exception %@", e);
    }
    
    if (vc != nil)
    {
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:CompletionBlock];
    }
    else
    {
        //The device cannot make payments. Please make sure Passbook has valid Credit Card added.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PassKit Payment Error"
                                                        message:NSLocalizedString(@"The device cannot make payment at this time. Please check Passbook has Valid Credit Card and Payment Request has Valid Currency & Apple MerchantID.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}

void (^CompletionBlock)(void) = ^
{
    NSLog(@"This is Completion block");
    
};

@end
