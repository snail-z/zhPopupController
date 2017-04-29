#
#  Be sure to run `pod spec lint SnailPopupController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    s.name         = "SnailPopupController"
    s.version      = "2.0.6"
    s.summary      = "Simple Popup Controller For iOS"
    s.license      = { :type => "MIT", :file => "LICENCE" }
    s.author       = { "snail-z" => "40460770@qq.com" }
    s.platform     = :ios, "7.0"
    s.homepage     = "https://github.com/snail-z/SnailPopupController"
    s.source       = { :git => "https://github.com/snail-z/SnailPopupController.git", :tag => s.version }
    s.source_files = "Sources/**/*.{h,m}"
    s.requires_arc = true

end
