# Uncomment the next line to define a global platform for your project
  platform :ios, '11.0'

def share_pods
  pod 'RxSwift'
  pod 'Moya'
end

def ios_pods
  pod 'SwiftGen'
  # pod 'RealmSwift'
  pod 'AlamofireImage'
  pod 'ObjectMapper'
  pod 'Action'
end

target 'News' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  share_pods
  ios_pods
  # Pods for News
  
  target 'NewsTests' do
    inherit! :search_paths
    # Pods for testing
    pod "RxTest"
    pod "Quick"
    pod "RxNimble"
    pod 'OHHTTPStubs/Swift'
  end

  target 'NewsUITests' do
    # Pods for testing
  end

end
