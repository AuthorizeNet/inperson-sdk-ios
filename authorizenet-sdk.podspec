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
  s.version          = "2.0.7"
  s.summary          = "iOS SDK for Authorize.Net Payments"
  s.description      = "The iOS SDK provides a fast and easy way for iPhone/iPad application developers to quickly integrate mobile payment without having to write the network communication, XML generation/parsing, and encoding of the data to the Authorize.net gateway."
  s.homepage         = "https://github.com/authorizenet/sdk-ios"
  s.license          = 'https://github.com/AuthorizeNet/sdk-ios/blob/master/LICENSE'
  s.author           = { "Authorize.Net" => "developer@authorize.net" }
  s.source           = { :git => "https://github.com/authorizenet/sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.vendored_frameworks = 'AnetEMVSdk.framework'
  s.source_files = 'AnetEMVSdk.framework/Headers/*.{h}'
  s.resources = 'AnetEMVSdk.framework/*.{mp3,storyboardc}'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.library = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES" }
end
