#Authorize.Net iOS SDK

[![Build Status](https://travis-ci.org/AuthorizeNet/sdk-ios.svg?branch=master)](https://travis-ci.org/AuthorizeNet/sdk-ios)

The iOS SDK provides a fast and easy way for iPhone/iPad application developers to quickly integrate mobile payment without having to write the network communication, XML generation/parsing, and encoding of the data to the Authorize.Net gateway.


## Try It

If you use [CocoaPods](http://cocoapods.org/) you can try our sample app with just a single command:

````
   $ pod try 'authorizenet-sdk'
````
 
## Installation
Installation is very simple with Cocoapods but you can also install manually.

#### Including our CocoaPod

1. Add our pod to your project Podfile:

        pod 'authorizenet-sdk'

1. Then run `pod install` or `pod update`

2. If you are running `pod install` for the first time you'll be reminded to always use the .xcworkspace file for your project rather that the xccodeproj

1. NOTE: You may need to add libxml2.dylib to "Link Binary with Libraries" build phase.



#### Including the SDK manually

1. Download the zip file of the SDK from `https://github.com/AuthorizeNet/sdk-ios/archive/master.zip` and unzip to your preferred location.
2. In XCode, select your project in Project Navigator and select File->Add Files to "" from the main menu bar.
3. In the file dialog, select the sdk folder from the unzipped directory in Step 1.
4. In the file dialog, make sure "Copy items into destination group's folder (if needed)" is checked and click Add button.


## Apple Pay

Check out [http://developer.authorize.net/api/applepay](http://developer.authorize.net/api/applepay) for all the developer resources you need to get going.

Our sample app will also walk you through an Apple Pay transaction on Authorize.Net.


## Building an MPoS Application

You can use our SDK to build a full featured Mobile Point-of-Sale application and we have a full [MPOS README](MPOS_README.md) to help you get started developing.


