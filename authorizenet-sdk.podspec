#
# Be sure to run `pod lib lint authorizenet-sdk.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "authorizenet-sdk"
  s.version          = "1.9.3"
  s.summary          = "iOS SDK for Authorize.Net Payments"
  s.description      = "The iOS SDK provides a fast and easy way for iPhone/iPad application developers to quickly integrate mobile payment without having to write the network communication, XML generation/parsing, and encoding of the data to the Authorize.net gateway."
  s.homepage         = "https://github.com/authorizenet/sdk-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'https://github.com/AuthorizeNet/sdk-ios/blob/master/LICENSE'
  s.author           = { "brianmc" => "bmcmanus@authorize.net" }
  s.source           = { :git => "https://github.com/authorizenet/sdk-ios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/AuthorizeNetDev'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'sdk/**/*.{h,m}'
  #s.resources = 'sdk/**/*.{xib,storyboard}'
  s.exclude_files = "**/AuthNetUnitTests.m"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'XCTest'
  s.library = 'xml2'
  #s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES" }
  # s.dependency 'AFNetworking', '~> 2.3'
end
