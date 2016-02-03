Pod::Spec.new do |s|
s.name     = 'YAlertView'
s.version  = '1.0.0'
s.license  = 'MIT'
s.summary  = 'a YAlertView.'
s.homepage = 'https://github.com/DoctorScholar/YAlertView'
s.author   = { 'yan qingshan' => 'iosscholar@sina.cn' }
s.source   = { :git => 'https://github.com/DoctorScholar/YAlertView.git', :tag => 'v1.0.0' }
s.platform = :ios
s.source_files = 'YAlertView/*'
s.framework = 'UIKit'

s.requires_arc = true
end