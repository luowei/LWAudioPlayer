#!/bin/sh

# pod trunk push ./LWAudioPlayer.podspec --verbose --allow-warnings

pod repo push mygitlabrepo LWAudioPlayer.podspec --verbose --allow-warnings --sources="https://gitlab.com/ioslibraries1/mygitlabrepo.git,https://github.com/CocoaPods/Specs.git"