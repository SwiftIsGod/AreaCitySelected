Pod::Spec.new do |spec|
  spec.name             = 'SelectedPicker'
  spec.version          = '1.1'
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/OneBestWay/AreaCitySelected'
  spec.authors          = { 'Gaojin' => 'github6909@gmail.com' }
  spec.summary          = 'Swift selected picker'
  spec.source           = { :git => 'https://github.com/OneBestWay/AreaCitySelected.git', :tag => 'v1.1' }
  spec.source_files     = 'SelectedPicker/*'
  spec.framework        = 'UIKit'
  spec.requires_arc     = true

  spec.ios.deployment_target = '8.0'
end

