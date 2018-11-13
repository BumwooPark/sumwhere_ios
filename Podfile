# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ZIP_ios' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ZIP_ios
# Utils
pod 'SnapKit'
pod 'SwiftyBeaver'
pod 'KakaoOpenSDK'
pod 'Kingfisher'
pod 'Hero'
pod 'SwiftyJSON'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Messaging'
pod 'ReachabilitySwift'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'
pod 'SwiftyImage'
pod 'TLPhotoPicker'
pod 'JTAppleCalendar'
pod 'PopupDialog'
pod 'SwiftyUserDefaults'
pod 'SwiftDate'
pod 'PySwiftyRegex'
pod 'Fabric'
pod 'Crashlytics'
pod 'MQTTClient'
pod 'CocoaMQTT' 
pod 'Result'
pod 'RealmSwift'
pod 'Firebase/AdMob'
pod 'Carte'

# UI
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'SkyFloatingLabelTextField'
pod 'TTTAttributedLabel'
pod 'LGButton'
pod 'JDStatusBarNotification'
pod 'LTMorphingLabel'
pod 'Eureka'
pod 'TagListView'
pod 'JVFloatLabeledTextField'
pod 'BubbleTransition'
pod 'Cosmos'
pod 'HMSegmentedControl'
pod 'SkeletonView'
pod 'Texture'
pod 'CHIPageControl'
pod 'CHIPageControl/Aleppo'
pod 'EmptyDataSet-Swift'
pod 'IGListKit'
pod 'NVActivityIndicatorView'


# RX
pod 'RxSwift'
pod 'RxCocoa'
pod 'RxGesture'
pod 'RxDataSources'
pod 'Moya/RxSwift'
pod 'RxKeyboard'
pod "RxSwiftExt"
pod 'RxCoreLocation'
pod "RxRealm"
pod 'RxGoogleMaps'

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
  at_exit { `ruby #{pods_dir}/Carte/Sources/Carte/carte.rb configure` }
end

