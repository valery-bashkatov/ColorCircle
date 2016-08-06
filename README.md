# ColorCircle

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)]()

## Description
A control for selecting a color from the palette.

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
And then follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to install the framework.

## Usage

### Programmatically
```swift
import ColorCircle

let colorCircle = ColorCircle()

colorCircle.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
```

### Interface Builder