#
# Be sure to run `pod lib lint ThirdPayModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ThirdPayModule'
    s.version          = '0.3.1'
    s.summary          = 'ThirdPayModule.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = 'ThirdPayModule:通过Cocoapods集成支付宝支付和微信支付，让你的开发更加迅捷'

    s.homepage         = 'https://github.com/nqwl'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'nqwl' => '1273087648@qq.com' }
    s.source           = { :git => 'https://github.com/nqwl/ThirdPayModule.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.subspec 'AliPay' do |ss|
#        ss.frameworks   = 'CoreTelephony', 'SystemConfiguration', 'CoreMotion','QuartzCore','CoreText','CoreGraphics'
        ss.frameworks = 'CoreTelephony', 'SystemConfiguration', 'CoreMotion'
        ss.libraries    = 'z', 'c++'
        ss.source_files = 'ThirdPayModule/Classes/AliPay/**/*.{h,m}'
        ss.resources    = 'ThirdPayModule/Assets/AlipaySDK.bundle'
        ss.vendored_frameworks = ['ThirdPayModule/Classes/AliPay/*.framework']
    end
    s.subspec 'WXPay' do |sss|
        sss.source_files = 'ThirdPayModule/Classes/WXPay/*.{h,m}'
        sss.dependency 'WechatOpenSDK'
    end
#     s.resource_bundles = {
#       'ThirdPayModule' => ['ThirdPayModule/Assets/*.png']
#     }

#     s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'MapKit'

end
