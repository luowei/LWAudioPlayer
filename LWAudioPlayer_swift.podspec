#
# LWAudioPlayer_swift.podspec
# Swift version of LWAudioPlayer
#

Pod::Spec.new do |s|
  s.name             = 'LWAudioPlayer_swift'
  s.version          = '1.0.0'
  s.summary          = 'Swift version of LWAudioPlayer - A dual-core audio player with advanced controls'

  s.description      = <<-DESC
LWAudioPlayer_swift is a modern Swift implementation of the LWAudioPlayer library.
A powerful dual-core audio player with support for:
- Forward/backward seeking with customizable intervals
- Loop/repeat modes (single, all, shuffle)
- Playback speed control (0.5x to 2.0x)
- SwiftUI and UIKit integration
- Combine framework support for reactive programming
- Modern Swift async/await patterns
- Type-safe audio item management
                       DESC

  s.homepage         = 'https://github.com/luowei/LWAudioPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWAudioPlayer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'LWAudioPlayer_swift/Classes/**/*'

  s.resource_bundles = {
    'LWAudioPlayer_swift' => ['LWAudioPlayer/Assets/**/*']
  }

  s.frameworks = 'UIKit', 'AVFoundation', 'MediaPlayer', 'SwiftUI', 'Combine'
  s.dependency 'Masonry'
end
