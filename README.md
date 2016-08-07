# ColorCircle

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)]()

## Description
A control for selecting a color from the palette.

## Appearance
![ColorCircle Image](https://cloud.githubusercontent.com/assets/18283239/17461764/bfe16c1e-5ca8-11e6-9b6a-7c47992d0c29.png)

## Requirements
- iOS 8.0+
- Xcode 7.3+

## Dependencies
- [ColorModel](https://github.com/valery-bashkatov/ColorModel)

## Installation
### Carthage

To integrate `ColorCircle` into your project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```
github "valery-bashkatov/ColorCircle"
```
And then follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to install the framework and its dependencies.

## Usage

### Programmatically
```swift
import ColorCircle

let colorCircle = ColorCircle()

colorCircle.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
colorCircle.addTarget(self, action: #selector(changeColor(_:)), forControlEvents: .ValueChanged)

view.addSubview(colorCircle)
```

### Interface Builder
![ColorCircle Interface Builder](https://cloud.githubusercontent.com/assets/18283239/17461787/2c80a8d0-5ca9-11e6-884a-4866eaa9d5b9.png)