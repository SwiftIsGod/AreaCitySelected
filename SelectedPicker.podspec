Pod::Spec.new do |spec|
  spec.name             = 'SelectedPicker'
  spec.version          = '1.0'
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/OneBestWay/AreaCitySelected'
  spec.authors          = { 'Gaojin' => 'github6909@gmail.com' }
  spec.summary          = 'Swift selected picker'
  spec.source           = { :git => 'https://github.com/OneBestWay/Reachability.git', :tag => 'v1.0' }
  spec.source_files     = 'SelectedPicker/*'
  spec.framework        = 'SystemConfiguration'
  spec.requires_arc     = true
end

