Pod::Spec.new do |s|
  s.name         = "SimpPerf"
  s.version      = "0.0.1"
  s.summary      = "A short description of AspectsHooks."
  s.description  = 'This is the description of the pod. this is just for test purposes.'
  s.homepage     = "https://github.com/biocross/SimPerf.git"
  s.license      = "MIT custom"
  s.author       = { "Chirag Ramani" => "chirag.ramani7@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/biocross/SimPerf.git", :tag => "#{s.version}" }
  s.source_files  = "SimPerf/*"
  s.dependency "Aspects"
end
