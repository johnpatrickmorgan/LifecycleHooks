
Pod::Spec.new do |s|

  s.name             = "LifecycleHooks"
  s.version          = "0.1.0"
  s.summary          = "Inject custom code into views and view controllers in response to lifecycle events."

  s.description      = <<-DESC
                        LifecycleHooks allows custom code to be injected into views and
                        view controllers in response to lifecycle events
                       DESC

  s.homepage         = "https://github.com/johnpatrickmorgan/LifecycleHooks"
  s.license          = 'MIT'
  s.author           = { "johnpatrickmorgan" => "johnpatrickmorganuk@gmail.com" }
  s.source           = { :git => "https://github.com/johnpatrickmorgan/LifecycleHooks.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jpmmusic'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
