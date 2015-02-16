Pod::Spec.new do |s|
  s.name         = "RQAnimations"
  s.version      = "0.0.1"
  s.summary      = "A collections of UI animations"

  s.description  = <<-DESC
                   RQAnimations is a collection of animations to add delight to
                   the appearance of UI elements.
                   DESC

  s.homepage      = "https://github.com/rqueue/RQAnimations"
  s.license       = "MIT"
  s.author        = { "Ryan Quan" => "ryanhquan@gmail.com" }
  s.source        = { :git => "https://github.com/rqueue/RQAnimations.git", :tag => "0.0.1" }
  s.source_files  = "RQAnimations", "RQAnimations/**/*.{h,m}"
end
