//
//  Pointers.swift
//
//  SlidingRuler
//
//  MIT License
//
//  Copyright (c) 2020 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


#if canImport(UIKit)
import UIKit
typealias BezierPath = UIBezierPath
#elseif canImport(AppKit)
import AppKit
typealias BezierPath = NSBezierPath
#endif

#if os(OSX)
import AppKit

public extension NSBezierPath {
    
    var cgPath: CGPath {
        get {
            let path = CGMutablePath()
            let points = NSPointArray.allocate(capacity: 3)
            
            for i in 0 ..< self.elementCount {
                let type = self.element(at: i, associatedPoints: points)
                switch type {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePath:
                    path.closeSubpath()
                case .cubicCurveTo:
                    fatalError("Encountered an unknown element type in NSBezierPath")
                case .quadraticCurveTo:
                    // TODO: Complete
                    fatalError("Encountered an unknown element type in NSBezierPath")
                @unknown default:
                    fatalError("Encountered an unknown element type in NSBezierPath")
                }
            }
            return path
        }
    }
    
    func addLine(to point: NSPoint) {
        self.line(to: point)
    }
    
    func addCurve(to point: NSPoint, controlPoint1: NSPoint, controlPoint2: NSPoint) {
        self.curve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    func addQuadCurve(to point: NSPoint, controlPoint: NSPoint) {
        self.curve(to: point,
                   controlPoint1: NSPoint(
                    x: (controlPoint.x - self.currentPoint.x) * (2.0 / 3.0) + self.currentPoint.x,
                    y: (controlPoint.y - self.currentPoint.y) * (2.0 / 3.0) + self.currentPoint.y),
                   controlPoint2: NSPoint(
                    x: (controlPoint.x - point.x) * (2.0 / 3.0) +  point.x,
                    y: (controlPoint.y - point.y) * (2.0 / 3.0) +  point.y))
    }
    
    
    
}
#endif

enum Pointers {
    static var standard: BezierPath {
        let path = BezierPath()

        path.move(to: CGPoint(x: 18.78348, y: 1.134168))
        path.addCurve(to: CGPoint(x: 19, y: 2.051366), controlPoint1: CGPoint(x: 18.925869, y: 1.418949), controlPoint2: CGPoint(x: 19, y: 1.732971))
        path.addLine(to: CGPoint(x: 19, y: 16.949083))
        path.addCurve(to: CGPoint(x: 16.949083, y: 19), controlPoint1: CGPoint(x: 19, y: 18.081774), controlPoint2: CGPoint(x: 18.081774, y: 19))
        path.addCurve(to: CGPoint(x: 16.031885, y: 18.78348), controlPoint1: CGPoint(x: 16.63069, y: 19), controlPoint2: CGPoint(x: 16.316668, y: 18.925869))
        path.addLine(to: CGPoint(x: 1.134168, y: 11.33462))
        path.addCurve(to: CGPoint(x: 0.21697, y: 8.583027), controlPoint1: CGPoint(x: 0.121059, y: 10.828066), controlPoint2: CGPoint(x: -0.289584, y: 9.596135))
        path.addCurve(to: CGPoint(x: 1.134168, y: 7.665829), controlPoint1: CGPoint(x: 0.415425, y: 8.186118), controlPoint2: CGPoint(x: 0.737259, y: 7.864284))
        path.addLine(to: CGPoint(x: 16.031885, y: 0.21697))
        path.addCurve(to: CGPoint(x: 18.78348, y: 1.134168), controlPoint1: CGPoint(x: 17.044994, y: -0.289584), controlPoint2: CGPoint(x: 18.276924, y: 0.121059))
        path.close()
        path.move(to: CGPoint(x: 30.21652, y: 1.134168))
        path.addCurve(to: CGPoint(x: 32.968113, y: 0.21697), controlPoint1: CGPoint(x: 30.723076, y: 0.121059), controlPoint2: CGPoint(x: 31.955006, y: -0.289584))
        path.addLine(to: CGPoint(x: 32.968113, y: 0.21697))
        path.addLine(to: CGPoint(x: 47.865833, y: 7.665829))
        path.addCurve(to: CGPoint(x: 48.783031, y: 8.583027), controlPoint1: CGPoint(x: 48.262741, y: 7.864284), controlPoint2: CGPoint(x: 48.584576, y: 8.186118))
        path.addCurve(to: CGPoint(x: 47.865833, y: 11.33462), controlPoint1: CGPoint(x: 49.289585, y: 9.596135), controlPoint2: CGPoint(x: 48.878941, y: 10.828066))
        path.addLine(to: CGPoint(x: 47.865833, y: 11.33462))
        path.addLine(to: CGPoint(x: 32.968113, y: 18.78348))
        path.addCurve(to: CGPoint(x: 32.050915, y: 19), controlPoint1: CGPoint(x: 32.683334, y: 18.925869), controlPoint2: CGPoint(x: 32.369312, y: 19))
        path.addCurve(to: CGPoint(x: 30, y: 16.949083), controlPoint1: CGPoint(x: 30.918226, y: 19), controlPoint2: CGPoint(x: 30, y: 18.081774))
        path.addLine(to: CGPoint(x: 30, y: 16.949083))
        path.addLine(to: CGPoint(x: 30, y: 2.051366))
        path.addCurve(to: CGPoint(x: 30.21652, y: 1.134168), controlPoint1: CGPoint(x: 30, y: 1.732971), controlPoint2: CGPoint(x: 30.074131, y: 1.418949))
        path.close()
        path.move(to: CGPoint(x: 24.5, y: 6))
        path.addCurve(to: CGPoint(x: 28, y: 9.5), controlPoint1: CGPoint(x: 26.432997, y: 6), controlPoint2: CGPoint(x: 28, y: 7.567003))
        path.addCurve(to: CGPoint(x: 24.5, y: 13), controlPoint1: CGPoint(x: 28, y: 11.432997), controlPoint2: CGPoint(x: 26.432997, y: 13))
        path.addCurve(to: CGPoint(x: 21, y: 9.5), controlPoint1: CGPoint(x: 22.567003, y: 13), controlPoint2: CGPoint(x: 21, y: 11.432997))
        path.addCurve(to: CGPoint(x: 24.5, y: 6), controlPoint1: CGPoint(x: 21, y: 7.567003), controlPoint2: CGPoint(x: 22.567003, y: 6))
        path.close()

#if canImport(UIKit)
        path.apply(.init(translationX: -24.5, y: 0))
#elseif canImport(AppKit)
        path.transform(using: AffineTransform(translationByX: -24.5, byY: 0))
#endif

        return path
    }
}
