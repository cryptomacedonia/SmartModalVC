#
# Be sure to run `pod lib lint SmartModalVC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SmartModalVC'
  s.version          = '0.0.1'
  s.summary          = 'Allows to quickly show intelligent modal views'
  s.swift_version = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Allows to quickly show intelligent modal views. For example, multiple selections, simple one of many or more complicated flows'


  s.homepage         = 'https://github.com/cryptomacedonia/SmartModalVC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cryptomacedonia' => 'igor@edit8.com' }
  s.source           = { :git => 'https://github.com/cryptomacedonia/SmartModalVC.git', :tag => s.version.to_s }


  s.ios.deployment_target = '14.5'

  s.source_files = 'SmartModalVC/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SmartModalVC' => ['SmartModalVC/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
