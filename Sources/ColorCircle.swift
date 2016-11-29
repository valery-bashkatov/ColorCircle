//
//  ColorCircle.swift
//  ColorCircle
//
//  Created by Valery Bashkatov on 07.08.16.
//  Copyright (c) 2016 Valery Bashkatov. All rights reserved.
//

import UIKit
import ColorModel

/**
 The `ColorCircle` class implements the control to select a color from the color circle.
 
 Control sends `UIControlEvents.ValueChanged` event.
 */
open class ColorCircle: UIControl {
    
    // MARK: - Properties
    
    /// The color palette.
    fileprivate var palette: UIImageView!
    
    /// The brightness layer.
    fileprivate var brightnessLayer: UIImageView!
    
    /// The cursor.
    fileprivate var cursor: UIView!
    
    /// The radius of the color palette.
    fileprivate var paletteRadius: CGFloat {
        return min(palette.bounds.midX, palette.bounds.midY)
    }
    
    /// The color model for working with color by the HSB components.
    fileprivate let colorModel = ColorModel(color: UIColor.white)
    
    /**
     The selected color.
     
     - note: To set the color, use `setColor(_:animated:sendEvent:)` method.
     */
    open var color: UIColor {
        return colorModel.color
    }
    
    // MARK: - Initialization
    
    /// :nodoc:
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// :nodoc:
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Makes initial setup.
    fileprivate func setup() {
        isOpaque = false
        isUserInteractionEnabled = true
        
        palette = UIImageView()
        palette.image = UIImage(named: "ColorCircle",
                                in: Bundle(for: type(of: self)),
                                compatibleWith: traitCollection)
        palette.isUserInteractionEnabled = false
        addSubview(palette)
        
        brightnessLayer = UIImageView()
        brightnessLayer.image = UIImage(named: "ColorCircleBrightness",
                                        in: Bundle(for: type(of: self)),
                                        compatibleWith: traitCollection)
        brightnessLayer.alpha = 0
        brightnessLayer.isUserInteractionEnabled = false
        palette.addSubview(brightnessLayer)
        
        cursor = UIView()
        cursor.frame.size = CGSize(width: 10, height: 10)
        cursor.layer.cornerRadius = cursor.bounds.width / 2
        cursor.layer.borderWidth = 1.5
        cursor.layer.borderColor = UIColor.white.cgColor
        cursor.layer.shadowOpacity = 0.5
        cursor.layer.shadowRadius = 1
        cursor.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        cursor.isUserInteractionEnabled = false
        palette.addSubview(cursor)
        
        palette.translatesAutoresizingMaskIntoConstraints = false
        brightnessLayer.translatesAutoresizingMaskIntoConstraints = false
        cursor.translatesAutoresizingMaskIntoConstraints = false
        
        // Palette constraints
        palette.widthAnchor.constraint(equalTo: palette.heightAnchor).isActive = true
        palette.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        palette.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        palette.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor).isActive = true
        palette.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor).isActive = true
        
        // Brightness layer constraints
        brightnessLayer.widthAnchor.constraint(equalTo: palette.widthAnchor).isActive = true
        brightnessLayer.heightAnchor.constraint(equalTo: palette.heightAnchor).isActive = true
        brightnessLayer.centerXAnchor.constraint(equalTo: palette.centerXAnchor).isActive = true
        brightnessLayer.centerYAnchor.constraint(equalTo: palette.centerYAnchor).isActive = true
        
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeBrightness(_:))))
    }
    
    // MARK: - Layout
    
    /// :nodoc:
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        setColor(colorModel.color, animated: false, sendEvent: false)
    }
    
    // MARK: - Event Handling
    
    /// :nodoc:
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let point = convert(point, to: palette)
        
        // Palette's circle contains point
        guard sqrt(pow(point.x - paletteRadius, 2) + pow(point.y - paletteRadius, 2)) <= paletteRadius else {
            return nil
        }
        
        return self
    }
    
    /// :nodoc:
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        guard event!.allTouches?.count == 1 else {
            return false
        }
        
        // Point in palette's coordinate system with origin in the center
        let palettePoint = convert(CGPoint(x: point.x - paletteRadius, y: point.y - paletteRadius), to: palette)
        
        // Hue = point angle / 2Pi
        let newHue = (-atan2(palettePoint.y, palettePoint.x) + (2 * .pi)).truncatingRemainder(dividingBy: 2 * .pi) / (2 * .pi)
        
        // Saturation = distance to point / palette radius
        let newSaturation = min(sqrt(pow(palettePoint.x, 2) + pow(palettePoint.y, 2)), paletteRadius) / paletteRadius
        
        colorModel.hue = newHue
        colorModel.saturation = newSaturation
        
        setColor(colorModel.color, animated: false, sendEvent: true)
        
        return true
    }
    
    /// :nodoc:
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        // Point in palette's coordinate system with origin in the center
        let palettePoint = convert(CGPoint(x: point.x - paletteRadius, y: point.y - paletteRadius), to: palette)
        
        // Hue = point angle / 2Pi
        let newHue = (-atan2(palettePoint.y, palettePoint.x) + (2 * .pi)).truncatingRemainder(dividingBy: 2 * .pi) / (2 * .pi)
        
        // Saturation = distance to point / palette radius
        let newSaturation = min(sqrt(pow(palettePoint.x, 2) + pow(palettePoint.y, 2)), paletteRadius) / paletteRadius
        
        colorModel.hue = newHue
        colorModel.saturation = newSaturation
        
        setColor(colorModel.color, animated: false, sendEvent: true)
        
        return true
    }
    
    // MARK: - Changing the Brightness
    
    /**
     Changes the brightness on pinch gesture.
     
     - parameter pinchGestureRecognizer: The `UIPinchGestureRecognizer` sender instance.
     */
    func changeBrightness(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        let oldBrightness = colorModel.brightness
        let newBrightness = min(max(oldBrightness + ((pinchGestureRecognizer.velocity.sign == .minus) ? -1 : 1) / paletteRadius, 0), 1)
        
        if newBrightness != oldBrightness {
            colorModel.brightness = newBrightness
            setColor(colorModel.color, animated: false, sendEvent: true)
        }
    }
    
    // MARK: - Setting the Color
    
    /**
     Sets the color.
     
     - parameter color: The color to set.
     - parameter animated: `true` if animate the change, and `false` if it should be immediately.
     - parameter sendEvent: A Boolean value specifying whether to send the action message.
     */
    open func setColor(_ color: UIColor, animated: Bool, sendEvent: Bool) {
        colorModel.color = color
        
        // Visually, color brightness is defined by transparency of brightnessLayer: brightness = 1 - brightnessLayer.alpha
        if brightnessLayer.alpha != 1 - colorModel.brightness {
            brightnessLayer.alpha = 1 - colorModel.brightness
        }
        
        // Hue = point angle / 2*Pi, saturation = distance to point, in palette's coordinate system with origin in the center
        let newCursorCenter = CGPoint(x:  cos(colorModel.hue * 2 * .pi) * (colorModel.saturation * paletteRadius) + paletteRadius,
                                      y: -sin(colorModel.hue * 2 * .pi) * (colorModel.saturation * paletteRadius) + paletteRadius)
        
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.cursor.backgroundColor = color
                self.cursor.center = newCursorCenter
            })
        } else {
            cursor.backgroundColor = color
            cursor.center = newCursorCenter
        }
        
        if sendEvent {
            sendActions(for: .valueChanged)
        }
    }
}
