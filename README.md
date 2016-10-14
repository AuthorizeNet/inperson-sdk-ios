# Authorize.Net In-Person iOS SDK Integration Guide

The Authorize.Net In-Person SDK provides a Semi-Integrated Solution for EMV payment processing. 

The merchant's app invokes this SDK to complete an EMV transaction. The SDK handles the complex EMV workflow and securely submits the EMV transaction to Authorize.Net for processing. The merchant's application never touches any EMV data at any point.
  
## Operational Workflow

1.	From POS application, select Pay By Card.

2.	Attached the card reader to the device if it is not already attached.

3.	Insert a card with an EMV chip and do not remove the card until the transaction is complete. Alternatively, swipe a non-EMV card.

4.	If only a single compatible payment app resides on the chip, the payment app is selected automatically. If prompted, select the payment app. For example, Visa credit or MasterCard debit.

5.	Confirm the amount.

6.	If at any time the user cancels the transaction, the transaction is cancelled. 

## Using the SDK to Create and Submit an EMV Transaction

1.	Include the In-Person iOS SDK framework in the merchantís application. 	Use Xcode to include the _AnetEMVSdk.framework_ file under Embedded Binaries. The merchant application must log in and initialize a valid Merchant object with the `PasswordAuthentication` field.

2.	Include additional frameworks and settings.

    a)	Include the _libxml2.2.tbd_ file in the app. 

    b)	Navigate to **Build Settings > Search Paths > Header Search Paths**.

    c)	Enter the following settings: `Iphoneos/usr/include/libxml2`.
    
    d)  This is required only if you are including SDK as static Library. Please link the following modules in your project
        AudioToolbox.framework
        CoreAudio.framework
        MediaPlayer.framework
        AVFoundation.framework
        CoreBluetooth.framework

3.	Copy Bundle Resources.

    a)	Include the `AnetEMVStoryBoard.storyboard` and `eject.mp3` fields from the _AnetEMVSdk.framework_ file in the application. If you included them correctly, you should be able to see Target > Build Phases > Copy Bundle Resources.

4.	If the application is developed in the Swift language, the application needs to have a bridging header file because the _AnetEMVSdk.framework_ file is based on Objective C.
 
5.	Initialize the _AnetEMVSdk.framework_ file.

    a)	Initialize _AnetEMVManager_ with US Currency and terminal ID.  Refer to the _AnetEMVManager.h_ file and the sample app for more details. Parameters include `skipSignature` and `showReceipt`.

    b)	`initWithCurrencyCode: terminalID: skipSignature: showReceipt`

    c)	Instantiate `AnetEMVTransactionRequest` and populate the required values, similar to `AuthNetRequest` for regular transactions If you are using swift to build your application then please don't static method provided by SDK to initialize the objects. Also, `AnetEMVSdk` requires the app to provide `presentingViewController`, a completion block to get the response from the SDK about the submitted transaction and cancelation block to execute the cancel action inside the SDK. 

    d)	The `EMVTransactionType` should be mentioned in the `AnetEMVTransactionRequest`. Refer to the _AnetEMVTransactionRequest.h_ file for all the available enums to populate.

    e)	After creating all the required objects, call the following method AnetEMVManager and submit the transaction. 

`[startEMVWithTransactionRequest:presentingViewController:completionBlock:andCancelActionBlock]`

**Note:** Only Goods, Services, and Payment are supported for the `TransactionType` field.

### Success

On success, the completion block should provide the `AnetEMVTransactionResponse` object with required information about the transaction response and isTransactionSuccessful will be true. Refer to _AnetEMVTransactionResponse.h_ for more details. `emvResponse` has `tlvdata` and all the tags as part of the response. 

### Errors

In case of a transaction error, the _AnetEMVTransactionResponse_ object should have the error details. 

In case of other errors, the _AnetEMVError_ object should be able to provide the details. 

Refer to _AnetEMVError.h_ for more details. Also refer to _AnetEMVManager.h_ for _ANETEmvErrorCode_ enum for more details on the errors. 

## Configuring the UI

You can configure the UI of the In-Person SDK to better match the UI of the merchant application.  The merchant application must initialize these values before using the SDK.  If no values are set or null is set for any of the parameters, the SDK defaults to its original theme.
  
The merchant application can configure the following UI parameters:

* Background Color

* Text Font Color

* Button Font Color

* Button Background Color

* Banner Image

* Banner Background Color

* Background Image

### Code Samples

The `AnetEMVUISettings` field exposes the properties to set:

**Background Color**  
`AnetEMVUISettings.sharedUISettings ().backgroundColor = [UIColor blueColor];`

**Text Font Color**  
`AnetEMVUISettings.sharedUISettings ().textFontColor = [UIColor blackColor];`

**Button Font Color**  
`AnetEMVUISettings.sharedUISettings ().buttonTextColor = [UIColor blueColor];`

**Button Background Color**  
`AnetEMVUISettings.sharedUISettings ().buttonColor = [UIColor blueColor];`

**Banner Image**  
`AnetEMVUISettings.sharedUISettings ().logoImage = [UIImage imageNamed:@îANetLogo.pngî];`

**Banner Background Color**  
`AnetEMVUISettings.sharedUISettings ().bannerBackgroundColor = [UIColor yellowColor];`

**Background Image**  
`AnetEMVUISettings.sharedUISettings ().backgroundImage = [UIImage imageNamed:@îANetBgImage.pngî];`

## Error  Codes
You can view these error messages at our [Reason Response Code](http://developer.authorize.net/api/reference/responseCodes.html) by entering the Response Reason Code into the tool. There will be additional information and suggestions there.

Field Order	| Response Code | Response Reason Code | Text
--- | --- | --- | ---
3 | 2 | 355	| An error occurred while parsing the EMV data.
3 | 2 | 356	| EMV-based transactions are not currently supported for this processor and card type.
3 | 2 | 357	| Opaque Descriptor is required.
3 | 2 | 358	| EMV data is not supported with this transaction type.
3 | 2 | 359	| EMV data is not supported with this market type.
3 | 2 | 360	| An error occurred while decrypting the EMV data.
3 | 2 | 361	| The EMV version is invalid.
3 | 2 | 362	| x_emv_version is required.
