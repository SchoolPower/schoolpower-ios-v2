# SchoolPower iOS V2

SchoolPower for iOS, iPadOS and macOS (via Mac Catalyst)

Rewrote of V1 in Swift 5 and SwiftUI for the redesigned interface, with additional features including the schedule (calendar) view. 

Tries to remove unnecessary dependance on third party libraries, which have been problematic to maintain in the past.

## Generate Screenshots
1. Choose your target device/simulator.
> Make sure the app (installed on that device) has the (in-app) language setting set to "System default" (if was manually changes before).
2. Run the [GatherScreenshots](https://github.com/SchoolPower/schoolpower-ios-v2/blob/master/SchoolPower/GatherScreenshots.xctestplan) test plan. This generats screenshots on the device for all locales.
3. After the test [passed](## "may fail due to various reasons (e.g. network timeouts), like all e2e tests. Just rerun until it passes."), run the [export script](https://github.com/SchoolPower/schoolpower-ios-v2/blob/master/exportScreenshots.sh). This takes the screenshots captured in the last test run and dumps them into `"./screenshots/{device name}"`. Note that [`xcparse`](https://github.com/ChargePoint/xcparse) is needed.
4. Repeat above for all devices you need.
> Screenshots for macOS captures the entire device screen
5. To make the screenshots available for web, run the [compress script](https://github.com/SchoolPower/schoolpower-ios-v2/blob/master/generateCompressedScreenshots.sh). This takes everything in `./screenshots`, compresses them and dumps them into `./screenshots-compressed`. It also generates a [images.json](https://github.com/SchoolPower/schoolpower-ios-v2/blob/master/screenshots-compressed/images.json) that specifies the list of images for the website to use, put it in the wibsite repo and rebuild the bundle. Just push the screenshots to master and the CDN will take care of the rest. 
> This is only for the screenshots in the "Gallery" section. Images in the top landing page will need to be manually photoshoped.
