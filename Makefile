bootstrap:
	make pod-install
	make carthage-bootstrap

# CocoaPods
pod-install:
	pod install && sh Scripts/pods_build.sh

# Carthage
carthage-bootstrap:
	carthage update --platform iOS