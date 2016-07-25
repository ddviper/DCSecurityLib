Pod::Spec.new do |s|
  s.name     = 'CPSecurityTools'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A delightful iOS ENcrypt && DEcrypt tool.'
  s.homepage = 'https://git.oschina.net/ddchub/CPSecurityTools'
  s.social_media_url = 'https://git.oschina.net/ddchub/CPSecurityTools'
  s.authors  = { 'Wade Dong' => '391565320@qq.com' }
  s.source   = { :git => 'https://git.oschina.net/ddchub/CPSecurityTools.git', :tag => s.version, :submodules => true }
  s.requires_arc = true
  
  s.public_header_files = 'CPSecurityTools/SecurityTools/CPSecurityTools.h'
  s.source_files = 'CPSecurityTools/SecurityTools/**.{h,m}'
 
  
  pch_AF = <<-EOS
#ifndef TARGET_OS_IOS
  #define TARGET_OS_IOS TARGET_OS_IPHONE
#endif

#ifndef TARGET_OS_WATCH
  #define TARGET_OS_WATCH 0
#endif

EOS
  s.prefix_header_contents = pch_AF
  s.ios.deployment_target = '7.0'

  s.subspec 'AES' do |ss|
    ss.source_files = 'CPSecurityTools/SecurityTools/AES/*.{h,m}'
    ss.public_header_files = 'CPSecurityTools/SecurityTools/AES/*.h'
  end

    s.subspec 'ENDEcryptTools' do |ss|
    ss.source_files = 'CPSecurityTools/SecurityTools/ENDEcryptTools/*.{h,m}'
    ss.public_header_files = 'CPSecurityTools/SecurityTools/ENDEcryptTools/*.h'
  end
  
    s.subspec 'MD5' do |ss|
    ss.source_files = 'CPSecurityTools/SecurityTools/MD5/*.{h,m}'
    ss.public_header_files = 'CPSecurityTools/SecurityTools/MD5/*.h'
  end
  
    s.subspec 'RSA' do |ss|
    ss.source_files = 'CPSecurityTools/SecurityTools/RSA/*.{h,m}'
    ss.public_header_files = 'CPSecurityTools/SecurityTools/RSA/*.h'
    ss.dependency 'OpenSSL-Static', '~> 1.0.2.c1'
  end

    s.subspec 'MediaFileDecrypt' do |ss|
    ss.source_files = 'CPSecurityTools/SecurityTools/MediaFileDecrypt/*.{h,m}'
    ss.public_header_files = 'CPSecurityTools/SecurityTools/MediaFileDecrypt/*.h'
    end
end
