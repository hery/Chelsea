Chelsea
=======

Yet another location-based chat app -- built on top of Foursquare.

## Background Info

Chelsea, also publicly known as **CheckChat**, was initially meant to be my side startup.
Apple, however, rejected the business plan based on paid layers of anonymity, and I would rather not use my time fighting with them over such dull issues as privacy and money. Thus, I'm giving up on the project, open-sourcing it, and will focus my time on a different non-profit project. If anyone reading this would like to pick it up, it's all yours. Just reach out and I'll guide you through it.

I've built the entire working client/server application.
The stack includes:

* [a WebSockets Tornado server](https://github.com/hery/ChelseaTornado)
* a MongoDB database 
* the iOS client

A few things broke with some late changes I made and possibly the iOS 8 release, but I'll try to fix them in the coming days.

## Requirements

* iOS 7 with the Foursquare app
* Xcode 5
* CocoaPods

## Build

Install dependencies with `pod install` and open workspace with `open Chelsea.xcworkspace`.

## Run

Due to the Foursquare app requirement, Chelsea requires an actual device to run and will not work on a simulator.

## Contact

* hery at ratsimihah dot com
* [@ratsimihah](https://twitter.com/ratsimihah) on Twitter

## License

Chelsea is available under the MIT license. See the LICENSE file for more info.
