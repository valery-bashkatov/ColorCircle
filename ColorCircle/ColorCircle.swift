//
//  ColorCircle.swift
//  ColorCircle
//
//  Created by Valery Bashkatov on 01.09.16.
//  Copyright (c) 2016 Valery Bashkatov. All rights reserved.
//

import UIKit
import ToolKit

/**
 The `ColorCircle` class implements the control to select a color from the color circle.
 
 Control sends `UIControlEvents.ValueChanged` event.
 */
public class ColorCircle: UIControl {
    
    // MARK: - Properties
    
    /// The color palette.
    private var palette: UIImageView!
    
    /// The brightness layer.
    private var brightnessLayer: UIImageView!
    
    /// The cursor.
    private var cursor: UIView!
    
    /// The radius of the color palette.
    private var paletteRadius: CGFloat {
        return min(palette.bounds.midX, palette.bounds.midY)
    }
    
    /// The color model for working with color by the HSB components.
    private let colorModel = ColorModel(color: UIColor.whiteColor())
    
    /**
     The selected color.
     
     - note: To set the color, use `setColor(_:animated:sendEvent:)` method.
     */
    public var color: UIColor {
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
    private func setup() {
        opaque = false
        userInteractionEnabled = true
        
        palette = UIImageView()
        palette.image = UIImage(named: "ColorCircle",
                                inBundle: NSBundle(forClass: self.dynamicType),
                                compatibleWithTraitCollection: traitCollection)
        palette.userInteractionEnabled = false
        addSubview(palette)
        
        brightnessLayer = UIImageView()
        brightnessLayer.image = UIImage(named: "ColorCircleBrightness",
                                        inBundle: NSBundle(forClass: self.dynamicType),
                                        compatibleWithTraitCollection: traitCollection)
        brightnessLayer.alpha = 0
        brightnessLayer.userInteractionEnabled = false
        palette.addSubview(brightnessLayer)
        
        cursor = UIView()
        cursor.frame.size = CGSize(width: 10, height: 10)
        cursor.layer.cornerRadius = cursor.bounds.width / 2
        cursor.layer.borderWidth = 1.5
        cursor.layer.borderColor = UIColor.whiteColor().CGColor
        cursor.layer.shadowOpacity = 0.5
        cursor.layer.shadowRadius = 1
        cursor.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        cursor.userInteractionEnabled = false
        palette.addSubview(cursor)
        
        palette.translatesAutoresizingMaskIntoConstraints = false
        brightnessLayer.translatesAutoresizingMaskIntoConstraints = false
        cursor.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            
            // Palette constraints
            palette.widthAnchor.constraintEqualToAnchor(palette.heightAnchor).active = true
            palette.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
            palette.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
            palette.widthAnchor.constraintLessThanOrEqualToAnchor(self.widthAnchor).active = true
            palette.heightAnchor.constraintLessThanOrEqualToAnchor(self.heightAnchor).active = true
            
            // Brightness layer constraints
            brightnessLayer.widthAnchor.constraintEqualToAnchor(palette.widthAnchor).active = true
            brightnessLayer.heightAnchor.constraintEqualToAnchor(palette.heightAnchor).active = true
            brightnessLayer.centerXAnchor.constraintEqualToAnchor(palette.centerXAnchor).active = true
            brightnessLayer.centerYAnchor.constraintEqualToAnchor(palette.centerYAnchor).active = true
        } else {
            
            // Palette constraints
            addConstraints([
                NSLayoutConstraint(item: palette,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: palette,
                    attribute: .Height,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: palette,
                    attribute: .CenterX,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .CenterX,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: palette,
                    attribute: .CenterY,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .CenterY,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: palette,
                    attribute: .Width,
                    relatedBy: .LessThanOrEqual,
                    toItem: self,
                    attribute: .Width,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: palette,
                    attribute: .Height,
                    relatedBy: .LessThanOrEqual,
                    toItem: self,
                    attribute: .Height,
                    multiplier: 1,
                    constant: 0)
                ])
            
            // Brightness layer constraints
            addConstraints([
                NSLayoutConstraint(item: brightnessLayer,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: palette,
                    attribute: .Width,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: brightnessLayer,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: palette,
                    attribute: .Height,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: brightnessLayer,
                    attribute: .CenterX,
                    relatedBy: .Equal,
                    toItem: palette,
                    attribute: .CenterX,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(item: brightnessLayer,
                    attribute: .CenterY,
                    relatedBy: .Equal,
                    toItem: palette,
                    attribute: .CenterY,
                    multiplier: 1,
                    constant: 0)
                ])
        }
        
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeBrightness(_:))))
    }
    
    // MARK: - Layout
    
    /// :nodoc:
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setColor(colorModel.color, animated: false, sendEvent: false)
    }
    
    // MARK: - Event Handling
    
    /// :nodoc:
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let point = convertPoint(point, toView: palette)
        
        // Palette's circle contains point
        guard sqrt(pow(point.x - paletteRadius, 2) + pow(point.y - paletteRadius, 2)) <= paletteRadius else {
            return nil
        }
        
        return self
    }
    
    /// :nodoc:
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        
        guard event!.allTouches()?.count == 1 else {
            return false
        }
        
        // Point in palette's coordinate system with origin in the center
        let palettePoint = convertPoint(CGPoint(x: point.x - paletteRadius, y: point.y - paletteRadius), toView: palette)
        
        // Hue = point angle / 2Pi
        let newHue = ((-atan2(palettePoint.y, palettePoint.x) + 2 * CGFloat(M_PI)) % (2 * CGFloat(M_PI))) / (2 * CGFloat(M_PI))
        
        // Saturation = distance to point / palette radius
        let newSaturation = min(sqrt(pow(palettePoint.x, 2) + pow(palettePoint.y, 2)), paletteRadius) / paletteRadius
        
        colorModel.hue = newHue
        colorModel.saturation = newSaturation
        
        setColor(colorModel.color, animated: false, sendEvent: true)
        
        return true
    }
    
    /// :nodoc:
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        
        // Point in palette's coordinate system with origin in the center
        let palettePoint = convertPoint(CGPoint(x: point.x - paletteRadius, y: point.y - paletteRadius), toView: palette)
        
        // Hue = point angle / 2Pi
        let newHue = ((-atan2(palettePoint.y, palettePoint.x) + 2 * CGFloat(M_PI)) % (2 * CGFloat(M_PI))) / (2 * CGFloat(M_PI))
        
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
    func changeBrightness(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        let oldBrightness = colorModel.brightness
        let newBrightness = min(max(oldBrightness + (pinchGestureRecognizer.velocity.isSignMinus ? -1 : 1) / paletteRadius, 0), 1)
        
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
    public func setColor(color: UIColor, animated: Bool, sendEvent: Bool) {
        colorModel.color = color
        
        // Visually, color brightness is defined by transparency of brightnessLayer: brightness = 1 - brightnessLayer.alpha
        if brightnessLayer.alpha != 1 - colorModel.brightness {
            brightnessLayer.alpha = 1 - colorModel.brightness
        }
        
        // Hue = point angle / 2*Pi, saturation = distance to point, in palette's coordinate system with origin in the center
        let newCursorCenter = CGPoint(x:  cos(colorModel.hue * 2 * CGFloat(M_PI)) * (colorModel.saturation * paletteRadius) + paletteRadius,
                                      y: -sin(colorModel.hue * 2 * CGFloat(M_PI)) * (colorModel.saturation * paletteRadius) + paletteRadius)
        
        if animated {
            UIView.animateWithDuration(0.1, animations: {
                self.cursor.backgroundColor = color
                self.cursor.center = newCursorCenter
            })
        } else {
            cursor.backgroundColor = color
            cursor.center = newCursorCenter
        }
        
        if sendEvent {
            sendActionsForControlEvents(.ValueChanged)
        }
    }
}
