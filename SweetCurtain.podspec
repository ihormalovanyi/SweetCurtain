Pod::Spec.new do |spec|

  spec.name         = "SweetCurtain"
  spec.version      = "0.9.2"
  spec.summary      = "A framework that provides the component that implements the content-curtain interface."
  spec.description = "A framework that provides CurtainController. CurtainController is a container view controller that implements a content-curtain interface. You can find a similar implementation in applications like Apple Maps, Find My, Stocks, etc."

  spec.homepage     = "https://ihor.pro"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Ihor Malovanyi" => "mail@ihor.pro" }

  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/multimediasuite/SweetCurtain.git", :tag => "#{spec.version}" }

  spec.source_files  = "SweetCurtain/**/*.{h,m,swift}"

  spec.swift_version = "5.5"

end
