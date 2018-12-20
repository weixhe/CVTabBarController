Pod::Spec.new do |s|
  s.name         = "CVTabBarController"    #存储库名称
  s.version      = "1.0.0"      #版本号，与tag值一致
  s.summary      = "CVTabBarController"  #简介
  s.swift_version= "4.2"
  s.description  = "简易封装tabbarController，可设置特殊item，角标数字+圆点，可设置大于5个item，并控制显示其中的某些item"  #描述
  s.homepage     = "https://github.com/weixhe/CVTabBarController"      #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
  s.author       = { "weixhe" => "workerwei@163.com" }  #作者
  s.platform     = :ios, "8.0"                  #支持的平台和版本号
  s.source       = { :git => "https://github.com/weixhe/CVTabBarController.git", :tag => "1.0.0" }         #存储库的git地址，以及tag值
  s.source_files =  "CVTabBarController/Classes/*.{swift}" #需要托管的源代码路径
  s.requires_arc = true #是否支持ARC

  # s.dependency "KeychainAccess"    #所依赖的第三方库，没有就不用写

end
