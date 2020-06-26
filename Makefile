bootstrap:
	make setup
	make pod-install
	make carthage-bootstrap

# Required
setup:
	if !type xcpretty > /dev/null 2>&1; then brew install xcpretty; fi

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