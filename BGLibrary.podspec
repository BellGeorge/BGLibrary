Pod::Spec.new do |s|
    s.name = 'BGLibrary'
    s.version = '0.0.1'
    s.summary = 'A Bell George intenal library with helper methods.'
    s.homepage = 'https://github.com/BellGeorge/BGLibrary'
    s.license = {
      :type => 'MIT',
      :file => 'LICENSE.md'
    }
    s.author = {'Lawrence Lomax' => 'lawrence@bellgeorge.com'}
    s.source = { 
      :git => 'git@github.com:BellGeorge/BGLibrary.git', 
      :commit => 'HEAD' 
    }
    s.platform = :ios, '5.0'
    s.framework = 'Foundation', 'UIKit', 'AVFoundation'
    s.preferred_dependency = 'Core'
    
    # Linker flags
    s.requires_arc = true
    
    #External Dependency is used for external libraries
    s.subspec 'External' do |ss|
        ss.source_files = 'External/**/*{h,m}'
    end

    #Core dependency means that others don't depend on it
    s.subspec 'Core' do |ss|
        ss.source_files = 'Classes/Core/**/*.{h,m}', 'Headers/*.h'

        #Common dependencies
        ss.dependency 'BGLibrary/External'
        ss.dependency 'BlocksKit'
        ss.dependency 'SSToolkit'
        ss.dependency 'ReactiveCocoa'
    end
    
    #Subspec for the Api Subspec
    s.subspec 'Api' do |ss|
        ss.source_files = 'Classes/Api/**/*.{h,m}'
        
        # Dependencies
        ss.dependency 'BGLibrary/Core'
        ss.dependency 'AFNetworking'
    end

    #Subspec for the ImageLoading using a File Database
    s.subspec 'ImageLoading' do |ss|
        ss.source_files = 'Classes/ImageLoading/**/*.{h,m}'
        
        # Dependencies
        ss.dependency 'BGLibrary/Core'
        ss.dependency 'OGImage', :podspec => 'https://raw.github.com/lawrencelomax/Specs/master/OGImage/0.0.1/OGImage.podspec'
    end
    
    #Subspec for the BGDataStore using a File Database
    s.subspec 'FileStore' do |ss|
        ss.source_files = 'Classes/FileStore/**/*.{h,m}'
        
        # Dependencies
        ss.dependency 'BGLibrary/Api'
    end
    
    # Nanostore has a subspec for the BGDataStore
    s.subspec 'NanoStore' do |ss|
        ss.source_files = 'Classes/NanoStore/**/*.{h,m}'

        # Dependencies
        ss.dependency 'BGLibrary/Core'
        ss.dependency 'BGLibrary/Api'
        ss.dependency 'NanoStore'
        ss.dependency 'SSZipArchive'
    end
    
    #Subspec for the BGDataStore using TouchDB
    s.subspec 'TouchDB' do |ss|
        # Dependencies
        ss.dependency 'BGLibrary/Core'
        ss.dependency 'BGLibrary/Api'
        ss.dependency 'TouchDB'
        ss.dependency 'SSZipArchive'
        ss.dependency 'CouchCocoa'
    end
    
    # Facebook wrapper
    s.subspec 'Facebook' do |ss|
        ss.source_files = 'Classes/Facebook/**/*.{h,m}'

        # Dependencies
        ss.dependency 'BGLibrary/Core'
        ss.dependency 'BGLibrary/Api'
        ss.dependency 'Facebook-iOS-SDK', '3.1.1'
        ss.dependency 'SSKeychain'
    end
    
end