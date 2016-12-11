# ColorCircle
`ColorCircle` is a control for color selection.

![ColorCircle Image](https://cloud.githubusercontent.com/assets/18283239/17461764/bfe16c1e-5ca8-11e6-9b6a-7c47992d0c29.png)

## Requirements
- iOS 9.0+
- Swift 3.0+

## Dependencies
- [ColorModel](https://github.com/valery-bashkatov/ColorModel)

## Installation
### Carthage
To integrate `ColorCircle` into your project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```
github "valery-bashkatov/ColorCircle" ~> 2.0.0
```
And then follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to install the framework and its dependencies.

## Documentation
API Reference is located at [http://valery-bashkatov.github.io/ColorCircle](http://valery-bashkatov.github.io/ColorCircle).

## Sample
```swift
import ColorCircle

let colorCircle = ColorCircle()

colorCircle.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
colorCircle.addTarget(self, action: #selector(changeColor), for: .valueChanged)

view.addSubview(colorCircle)

func changeColor() {
    print(colorCircle.color)
}
```