//
//  CreditCardViewController.m
//  AuthnetLab
//
//  Created by Shankar Gosain on 07/23/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "CreditCardViewController.h"
#import "NSString+HMAC_MD5.h"

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
#define PAYMENT_SUCCESSFUL @"Your transaction of $0.01 has successfully been processed."



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
    
    UIAlertView *PaumentSuccess = [[UIAlertView alloc] initWithTitle:@"Successfull Transaction" message:PAYMENT_SUCCESSFUL delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"LOGOUT",nil];
    [PaumentSuccess show];
}

- (void)paymentCanceled {
    
    NSLog(@"Payment Canceled ********************** ");
    
    [_activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) requestFailed:(AuthNetResponse *)response {
    
    NSLog(@"Payment Canceled ********************** ");
    
    [_activityIndicator stopAnimating];
    
    Messages *ma = response.anetApiResponse.messages;
    AuthNetMessage *m = [ma.messageArray objectAtIndex:0];
    
    // Since submitting same transaction with same data, showing user the alert msg.
    if ([m.code isEqualToString:@"E00027"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"A duplicate transaction has been submitted. Login back into the app to see the successful transaction.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([m.code isEqualToString:@"E00007"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Your session has timed out. Please log in again.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
}

- (void) connectionFailed:(AuthNetResponse *)response {
    NSLog(@"%@", response.responseReasonText);
    NSLog(@"Connection Failed");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if ([response errorType] == NO_CONNECTION_ERROR) {
        title = NSLocalizedString(@"No Signal", @"");
        message = NSLocalizedString(@"Unable to complete your request. No Internet connection.", @"");
    } else {
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
    
    
    // ApplePay without Passkit using fake FingerPrint and Blob
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
    
    
    transactionRequestType.amount = [NSString stringWithFormat:@"%@",totalAmount];
    transactionRequestType.payment = paymentType;
    transactionRequestType.retail.marketType = @"0";
    transactionRequestType.retail.deviceType = @"7";
    
    OrderType *orderType = [OrderType order];
    orderType.invoiceNumber = invoiceNumber;
    NSLog(@"Invoice Number Before Sending the Request %@", orderType.invoiceNumber);
    
    return transactionRequestObj;
}

-(void) createTransactionWithOutPassKit
{
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // This part of the code that generates the finger print is present here only to make the sample app work.
    // Finger print generation should be done on the server.
    
    NSString *apiLogID                       = @"5KP3u95bQpv";
    NSString *transactionSecretKey           = @"4Ktq966gC55GAX7S";
    
    NSInteger sequenceNumber = arc4random() % 100;
    NSLog(@"Invoice Number [Random]: %ld", (long)sequenceNumber);
    
    
    NSNumber *aNumber = [NSNumber numberWithDouble:0.01];
    NSDecimalNumber *totalAmount = [NSDecimalNumber decimalNumberWithDecimal:[aNumber decimalValue]];
    NSLog(@"Total Amount: %@", totalAmount);
    
    
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
                                                                                      dataDescriptor:@"COMMON.APPLE.INAPP.PAYMENT"
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
    return @"eyJkYXRhIjoiQkRQTldTdE1tR2V3UVVXR2c0bzdFXC9qKzFjcTFUNzhxeVU4NGI2N2l0amNZSTh3UFlBT2hzaGpoWlBycWRVcjRYd1BNYmo0emNHTWR5KysxSDJWa1BPWStCT01GMjV1YjE5Y1g0bkN2a1hVVU9UakRsbEIxVGdTcjhKSFp4Z3A5ckNnc1NVZ2JCZ0tmNjBYS3V0WGY2YWpcL284WkliS25yS1E4U2gwb3VMQUtsb1VNbit2UHU0K0E3V0tycXJhdXo5SnZPUXA2dmhJcStIS2pVY1VOQ0lUUHlGaG1PRXRxK0grdzB2UmExQ0U2V2hGQk5uQ0hxenpXS2NrQlwvMG5xTFpSVFliRjBwK3Z5QmlWYVdIZWdoRVJmSHhSdGJ6cGVjelJQUHVGc2ZwSFZzNDhvUExDXC9rXC8xTU5kNDdrelwvcEhEY1JcL0R5NmFVTStsTmZvaWx5XC9RSk4rdFMzbTBIZk90SVNBUHFPbVhlbXZyNnhKQ2pDWmxDdXcwQzltWHpcL29iSHBvZnVJRVM4cjljcUdHc1VBUERwdzdnNjQybTRQendLRitIQnVZVW5lV0RCTlNEMnU2amJBRzMiLCJ2ZXJzaW9uIjoiRUNfdjEiLCJoZWFkZXIiOnsiYXBwbGljYXRpb25EYXRhIjoiOTRlZTA1OTMzNWU1ODdlNTAxY2M0YmY5MDYxM2UwODE0ZjAwYTdiMDhiYzdjNjQ4ZmQ4NjVhMmFmNmEyMmNjMiIsInRyYW5zYWN0aW9uSWQiOiJjMWNhZjVhZTcyZjAwMzlhODJiYWQ5MmI4MjgzNjM3MzRmODViZjJmOWNhZGYxOTNkMWJhZDlkZGNiNjBhNzk1IiwiZXBoZW1lcmFsUHVibGljS2V5IjoiTUlJQlN6Q0NBUU1HQnlxR1NNNDlBZ0V3Z2ZjQ0FRRXdMQVlIS29aSXpqMEJBUUloQVBcL1wvXC9cLzhBQUFBQkFBQUFBQUFBQUFBQUFBQUFcL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL01Gc0VJUFwvXC9cL1wvOEFBQUFCQUFBQUFBQUFBQUFBQUFBQVwvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cLzhCQ0JheGpYWXFqcVQ1N1BydlZWMm1JYThaUjBHc014VHNQWTd6ancrSjlKZ1N3TVZBTVNkTmdpRzV3U1RhbVo0NFJPZEpyZUJuMzZRQkVFRWF4ZlI4dUVzUWtmNHZPYmxZNlJBOG5jRGZZRXQ2ek9nOUtFNVJkaVl3cFpQNDBMaVwvaHBcL200N242MHA4RDU0V0s4NHpWMnN4WHM3THRrQm9ONzlSOVFJaEFQXC9cL1wvXC84QUFBQUFcL1wvXC9cL1wvXC9cL1wvXC9cLys4NXZxdHB4ZWVoUE81eXNMOFl5VlJBZ0VCQTBJQUJHbStnc2wwUFpGVFwva0RkVVNreHd5Zm84SnB3VFFRekJtOWxKSm5tVGw0REdVdkFENEdzZUdqXC9wc2hCWjBLM1RldXFEdFwvdERMYkUrOFwvbTB5Q21veHc9IiwicHVibGljS2V5SGFzaCI6IlwvYmI5Q05DMzZ1QmhlSEZQYm1vaEI3T28xT3NYMkora0pxdjQ4ek9WVmlRPSJ9LCJzaWduYXR1cmUiOiJNSUlEUWdZSktvWklodmNOQVFjQ29JSURNekNDQXk4Q0FRRXhDekFKQmdVckRnTUNHZ1VBTUFzR0NTcUdTSWIzRFFFSEFhQ0NBaXN3Z2dJbk1JSUJsS0FEQWdFQ0FoQmNsK1BmMytVNHBrMTNuVkQ5bndRUU1Ba0dCU3NPQXdJZEJRQXdKekVsTUNNR0ExVUVBeDRjQUdNQWFBQnRBR0VBYVFCQUFIWUFhUUJ6QUdFQUxnQmpBRzhBYlRBZUZ3MHhOREF4TURFd05qQXdNREJhRncweU5EQXhNREV3TmpBd01EQmFNQ2N4SlRBakJnTlZCQU1lSEFCakFHZ0FiUUJoQUdrQVFBQjJBR2tBY3dCaEFDNEFZd0J2QUcwd2daOHdEUVlKS29aSWh2Y05BUUVCQlFBRGdZMEFNSUdKQW9HQkFOQzgra2d0Z212V0YxT3pqZ0ROcmpURUJSdW9cLzVNS3ZsTTE0NnBBZjdHeDQxYmxFOXc0ZklYSkFEN0ZmTzdRS2pJWFlOdDM5ckx5eTd4RHdiXC81SWtaTTYwVFoyaUkxcGo1NVVjOGZkNGZ6T3BrM2Z0WmFRR1hOTFlwdEcxZDlWN0lTODJPdXA5TU1vMUJQVnJYVFBITmNzTTk5RVBVblBxZGJlR2M4N20wckFnTUJBQUdqWERCYU1GZ0dBMVVkQVFSUk1FK0FFSFpXUHJXdEpkN1laNDMxaENnN1lGU2hLVEFuTVNVd0l3WURWUVFESGh3QVl3Qm9BRzBBWVFCcEFFQUFkZ0JwQUhNQVlRQXVBR01BYndCdGdoQmNsK1BmMytVNHBrMTNuVkQ5bndRUU1Ba0dCU3NPQXdJZEJRQURnWUVBYlVLWUNrdUlLUzlRUTJtRmNNWVJFSW0ybCtYZzhcL0pYditHQlZRSmtPS29zY1k0aU5ERkFcL2JRbG9nZjlMTFU4NFRId05SbnN2VjNQcnY3UlRZODFncTBkdEM4elljQWFBa0NISUkzeXFNbko0QU91NkVPVzlrSmsyMzJnU0U3V2xDdEhiZkxTS2Z1U2dRWDhLWFFZdVpMazJScjYzTjhBcFhzWHdCTDNjSjB4Z2VBd2dkMENBUUV3T3pBbk1TVXdJd1lEVlFRREhod0FZd0JvQUcwQVlRQnBBRUFBZGdCcEFITUFZUUF1QUdNQWJ3QnRBaEJjbCtQZjMrVTRwazEzblZEOW53UVFNQWtHQlNzT0F3SWFCUUF3RFFZSktvWklodmNOQVFFQkJRQUVnWUJhSzNFbE9zdGJIOFdvb3NlREFCZitKZ1wvMTI5SmNJYXdtN2M2VnhuN1phc05iQXEzdEF0OFB0eSt1UUNnc3NYcVprTEE3a3oyR3pNb2xOdHY5d1ltdTlVandhcjFQSFlTK0JcL29Hbm96NTkxd2phZ1hXUnowbk1vNXkzTzFLelgwZDhDUkhBVmE4OFNyVjFhNUpJaVJldjNvU3RJcXd2NXh1WmxkYWc2VHI4dz09In0=";
}

// ApplyPay demo section

- (void) performTransactionWithEncryptedPaymentData: (NSString*) encryptedPaymentData withPaymentAmount: (NSString*) paymnetAmount
{
    
    NSDecimalNumber* amount = [NSDecimalNumber decimalNumberWithString:paymnetAmount];
    NSDecimalNumber* invoiceNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
    NSTimeInterval fingerprintTimestamp = [[NSDate date] timeIntervalSince1970];
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // This part of the code that generates the finger print is present here only to make the sample app work.
    // Finger print generation should be done on the server.
    
    NSString *fingerprintHashValue = [self prepareFPHashValueWithApiLoginID:@"34YTZ9mv39W"
                                                       transactionSecretKey:@"4C2ggME74k33T5rw"
                                                             sequenceNumber:invoiceNumber.longValue
                                                                totalAmount:amount
                                                                  timeStamp:fingerprintTimestamp];
    
    CreateTransactionRequest * transactionRequestObj = [self createTransactionReqObjectWithApiLoginID:@"34YTZ9mv39W"
                                                                                  fingerPrintHashData:fingerprintHashValue
                                                                                       sequenceNumber:invoiceNumber.intValue
                                                                                      transactionType:CAPTURE_ONLY
                                                                                      opaqueDataValue:encryptedPaymentData
                                                                                       dataDescriptor:@"FID=COMMON.APPLE.INAPP.PAYMENT"
                                                                                        invoiceNumber:invoiceNumber.stringValue
                                                                                          totalAmount:amount
                                                                                          fpTimeStamp:fingerprintTimestamp];
    if (transactionRequestObj != nil)
    {
        
        AuthNet *authNet = [AuthNet getInstance];
        [authNet setDelegate:self];
        
        authNet.environment = ENV_LIVE;
        [authNet purchaseWithRequest:transactionRequestObj];
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


// PassKit Delegate handlers

#pragma mark - Authorization delegate methods

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    if (payment) {
        // Go off and auth the card
        NSString *amount = @"0.01"; // Get the payment amount
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init] ;
        //get payment amount from payment token?
        ////////////////////////////////////////////////////////////////////////////
        //////Get opaque data from token
        NSData* test = payment.token.paymentData;
        NSString *base64string = [CreditCardViewController  base64forData:payment.token.paymentData];
        
        [self performTransactionWithEncryptedPaymentData:base64string withPaymentAmount:amount];
        
        completion(PKPaymentAuthorizationStatusSuccess);
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void )presentPaymentController
{
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    request.currencyCode = @"USD";
    request.countryCode = @"US";
    
    // put correct merchanrt Identifier here - this merchant identifier needs to be the same
    // with the value set in com.apple.developer.in-app-payments array
    
    request.merchantIdentifier = @"merchant.net.authorize.prod_merch1"; // set your merchant_id here
    request.applicationData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    request.merchantCapabilities = PKMerchantCapability3DS;
    request.supportedNetworks = @[PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkAmex];
    // request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    
    
    ///Set amount here
    NSString *amountText =  @"0.01"; // Get the payment amount
    NSDecimalNumber *amountValue = [NSDecimalNumber decimalNumberWithString:amountText];
    
    PKPaymentSummaryItem *item = [[PKPaymentSummaryItem alloc] init];
    item.amount = amountValue;
    //item.amount = [[NSDecimalNumber alloc] initWithInt:20];
    item.label = @"Test Payment Total";
    
    request.paymentSummaryItems = @[item];
    
    // need to setup correct entitlement to make the view to show
    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
