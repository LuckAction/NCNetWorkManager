Pod::Spec.new do |s|
  s.name     = 'NCNetWorkingManager'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A delightful iOS NCNetWorkingManager framework.'
  s.homepage = 'https://github.com/LuckAction/NCNetWorkingManager'
  s.authors  = { ‘luck chen' => ‘15521437974@163.com' }
  s.source   = { :git => 'https://github.com/LuckAction/NCNetWorkingManager.git', :tag => s.version, :submodules => true }
   s.source_files = ‘NCNetWorkingManager/*.{h,m}' 
  s.requires_arc = true
  s.platform = :ios
  s.public_header_files = 'LuckAction/NCNetWorkingManager.h'
 end
