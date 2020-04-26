Pod::Spec.new do |s|

s.name = "WCore"
s.summary = "WCore provides core functions for Wasteland."
s.version = "0.1.0"

s.license = { :type => "Proprietary", :file => "LICENSE" }
s.author = { "Liam Stevenson" => "liam923@verizon.net" }
s.homepage = "https://github.com/liam923/wasteland"

s.platform = :ios
s.ios.deployment_target = '13.0'
s.requires_arc = true
s.source = { :path => '.' }
s.source_files = "WCore/**/*.{swift}"
s.swift_version = "5"

s.dependency 'Firebase/Analytics'
s.dependency 'Firebase/Auth'
s.static_framework = true
s.dependency 'GoogleSignIn'
s.dependency 'Firebase/Firestore'
s.dependency 'FirebaseFirestoreSwift'
s.dependency 'CodableFirebase'

end
