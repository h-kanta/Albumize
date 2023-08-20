# Uncomment the next line to define a global platform for your project
platform :ios, '16.4'

target 'Albumize' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Albumize
  
  # Firebase
  pod 'FirebaseAuth'
  pod 'FirebaseCore'
  pod 'FirebaseStorage'
  pod 'FirebaseFirestore'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end
