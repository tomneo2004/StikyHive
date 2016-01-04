post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited), PodsDummy_Pods=SomeOtherNamePodsDummy_Pods'
        end
    end
end

platform :ios, '7.0'
pod 'SendGrid', '~>  0.2.6'

platform :ios, '7.0'
pod "AFNetworking", "~> 2.0"


platform :ios, '7.0'
pod 'PayPal-iOS-SDK'

pod 'ActionSheetPicker-3.0', '~> 2.0.4'

pod 'RadioButton'

platform :ios, '7.0'
pod 'Toast', '~> 3.0'
