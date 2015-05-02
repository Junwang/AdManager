Pod::Spec.new do |s|
    s.name = 'AdManager'
    s.version = '0.1'
    s.license = 'MIT'
    s.summary = 'Ad Manager'
    s.homepage = 'http://playhaven.com'
    s.author = { 'Jun Wang' => 'junwang3210@gmail.com' }
    s.source = { :git => 'https://github.com/Junwang/AdManager.git', :tag => '0.1' }
    s.description = "Ad Manager"
    s.platform = :ios
	s.source_files = "Classes/**/*.{h,m}"
    s.weak_frameworks = 'Webkit'
     s.xcconfig         = { 'FRAMEWORK_SEARCH_PATHS' =>    '"${PODS_ROOT}/Google-Mobile-Ads-SDK/GoogleMobileAdsSdkiOS-7.2.1"'}
	s.dependency 'Google-Mobile-Ads-SDK'

end