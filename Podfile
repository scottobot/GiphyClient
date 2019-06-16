platform :ios, '9.0'
use_frameworks!

target 'GiphyClient' do
  pod 'ObjectMapper'
  pod 'Alamofire'
  pod 'FLAnimatedImage'
  pod 'CHTCollectionViewWaterfallLayout/Swift'
end

post_install do |installer|
    print "Setting the default SWIFT_VERSION to 5.0\n"
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
    end
    
    installer.pods_project.targets.each do |target|
        if [].include? "#{target}"
            print "Setting #{target}'s SWIFT_VERSION to 4.2\n"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
            else
            print "Setting #{target}'s SWIFT_VERSION to Undefined (Xcode will automatically resolve)\n"
            target.build_configurations.each do |config|
                config.build_settings.delete('SWIFT_VERSION')
            end
        end
    end
end
