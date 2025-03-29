.DEFAULT_GOAL := setup
setup:
	fvm flutter pub get
	fvm dart run build_runner build --delete-conflicting-outputs