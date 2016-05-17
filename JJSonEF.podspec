Pod::Spec.new do |s|

  s.name         = "JJSonEF"
  s.version      = "0.0.2"
  s.summary      = "JJSonEF"
  s.description  = <<-DESC
                   简单的字典转模型 
                   DESC

  s.homepage     = "https://github.com/wangjinwei0806/JJSonEF"

  s.license      = "MIT"
  s.author             = { "wangjinwei" => "21418925@qq.com" }
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/wangjinwei0806/JJSonEF.git", :tag => s.version.to_s }

  s.source_files = "JJSonEF/*"

   s.requires_arc = true

end