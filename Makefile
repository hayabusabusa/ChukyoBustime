bootstrap:
	make pod-install
	make carthage-bootstrap

# CocoaPods
pod-install:
	pod install && sh Scripts/pods_build.sh

pod-update:
	pod update

# Carthage
carthage-update:
	carthage update --platform iOS

carthage-bootstrap:
	carthage bootstrap --platform iOS