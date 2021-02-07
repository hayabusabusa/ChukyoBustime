platform :ios, '11.0'

install! 'cocoapods', generate_multiple_pod_projects: true, incremental_installation: true, integrate_targets: false

inhibit_all_warnings!

use_modular_headers!

target 'Core' do
  use_frameworks!
  
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Crashlytics'
end
