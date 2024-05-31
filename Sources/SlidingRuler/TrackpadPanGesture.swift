//
//  TrackpadPanGesture.swift
//  SlidingRulerXcode
//
//  Created by Cyril Zakka on 5/31/24.
//

import SwiftUI

//struct CaptureVerticalScrollWheelModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .background(ScrollWheelHandlerView())
//    }
//
//    struct ScrollWheelHandlerView: NSViewRepresentable {
//        func makeNSView(context: Context) -> NSView {
//            let view = ScrollWheelReceivingView()
//            return view
//        }
//
//        func updateNSView(_ nsView: NSView, context: Context) {}
//    }
//
//    class ScrollWheelReceivingView: NSView {
//        private var scrollVelocity: CGFloat = 0
//        private var decelerationTimer: Timer?
//
//        override var acceptsFirstResponder: Bool { true }
//
//        override func viewDidMoveToWindow() {
//            super.viewDidMoveToWindow()
//            window?.makeFirstResponder(self)
//        }
//
//        override func scrollWheel(with event: NSEvent) {
//            var scrollDist = event.deltaX
//            var scrollDelta = event.scrollingDeltaX
//            
//            if event.phase == .began || event.phase == .changed || event.phase.rawValue == 0 {
//                // Directly handle scrolling
//                handleScroll(with: scrollDist, precise: event.hasPreciseScrollingDeltas)
//
//                scrollVelocity = scrollDelta
//            } else if event.phase == .ended {
//                // Begin decelerating
//                decelerationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] timer in
//                    guard let self = self else { timer.invalidate(); return }
//                    self.decelerateScroll()
//                }
//            } else if event.momentumPhase == .ended {
//                // Invalidate the timer if momentum scrolling has ended
//                decelerationTimer?.invalidate()
//                decelerationTimer = nil
//            }
//        }
//
//        private func handleScroll(with delta: CGFloat, precise: Bool) {
//            var scrollDist = delta
//            if !precise {
//                scrollDist *= 2
//            }
//
//            guard let scrollView = self.enclosingScrollView else { return }
//            let contentView = scrollView.contentView
//            let contentSize = contentView.documentRect.size
//            let scrollViewSize = scrollView.bounds.size
//
//            let currentPoint = contentView.bounds.origin
//            var newX = currentPoint.x - scrollDist
//
//            // Calculate the maximum allowable X position (right edge of content)
//            let maxX = contentSize.width - scrollViewSize.width
//            // Ensure newX does not exceed the bounds
//            newX = max(newX, 0) // No less than 0 (left edge)
//            newX = min(newX, maxX) // No more than maxX (right edge)
//
//            // Scroll to the new X position if it's within the bounds
//            scrollView.contentView.scroll(to: NSPoint(x: newX, y: currentPoint.y))
//            scrollView.reflectScrolledClipView(scrollView.contentView)
//        }
//
//        private func decelerateScroll() {
//            if abs(scrollVelocity) < 0.8 {
//                decelerationTimer?.invalidate()
//                decelerationTimer = nil
//                return
//            }
//
//            handleScroll(with: scrollVelocity, precise: true)
//            scrollVelocity *= 0.95
//        }
//    }
//}
//
//extension View {
//    func captureVerticalScrollWheel() -> some View {
//        self.modifier(CaptureVerticalScrollWheelModifier())
//    }
//}

#if canImport(AppKit)
protocol ScrollViewDelegateProtocol {
    /// Informs the receiver that the mouse’s scroll wheel has moved.
    func scrollWheel(with event: NSEvent)
    func scrollWheelDidBegin(with event: NSEvent)
    func scrollWheelDidEnd(with event: NSEvent)
    func scrollWheelDidCancel(with event: NSEvent)
}

class WrappedScrollView: NSView {
    
    private var scrollVelocity: CGFloat = 0
    private var decelerationTimer: Timer?
    
    /// Connection to the SwiftUI view that serves as the interface to our AppKit view.
    var delegate: ScrollViewDelegateProtocol!
    /// Let the responder chain know we will respond to events.
    override var acceptsFirstResponder: Bool { true }
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }
    /// Informs the receiver that the mouse’s scroll wheel has moved.
    override func scrollWheel(with event: NSEvent) {
        
        if event.phase == .mayBegin {
            
        } else if event.phase == .cancelled {
            delegate.scrollWheelDidCancel(with: event)
        } else if event.phase == .began {
            delegate.scrollWheelDidBegin(with: event)
        } else if event.phase == .changed || event.phase == .stationary {
            delegate.scrollWheel(with: event)
        } else if event.phase == .ended {
            delegate.scrollWheelDidEnd(with: event)
        }
    }
    
    
}

struct RepresentableScrollView: NSViewRepresentable, ScrollViewDelegateProtocol {
    /// The AppKit view our SwiftUI view manages.
    typealias NSViewType = WrappedScrollView
    
    /// What the SwiftUI content wants us to do when the mouse's scroll wheel is moved.
    private var scrollAction: ((NSEvent) -> Void)?
    private var scrollActionBegan: ((NSEvent) -> Void)?
    private var scrollActionEnded: ((NSEvent) -> Void)?
    private var scrollActionCancelled: ((NSEvent) -> Void)?
    
    /// Creates the view object and configures its initial state.
    func makeNSView(context: Context) -> WrappedScrollView {
        // Make a scroll view and become its delegate
        let view = WrappedScrollView()
        view.delegate = self;
        return view
    }
    
    /// Updates the state of the specified view with new information from SwiftUI.
    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
    
    /// Informs the representable view  that the mouse’s scroll wheel has moved.
    func scrollWheel(with event: NSEvent) {
        if let scrollAction = scrollAction {
            scrollAction(event)
        }
    }
    
    func scrollWheelDidBegin(with event: NSEvent) {
        if let scrollAction = scrollActionBegan {
            scrollAction(event)
        }
    }
    
    func scrollWheelDidCancel(with event: NSEvent) {
        if let scrollAction = scrollActionCancelled {
            scrollAction(event)
        }
    }
    
    func scrollWheelDidEnd(with event: NSEvent) {
        if let scrollAction = scrollActionEnded {
            scrollAction(event)
        }
    }
    
    /// Modifier that allows the content view to set an action in its context.
    func onScroll(action: @escaping (NSEvent) -> Void, onBegan: @escaping (NSEvent) -> Void = { _ in }, onEnded: @escaping (NSEvent) -> Void = { _ in }, onCancelled: @escaping (NSEvent) -> Void = { _ in }) -> Self {
        var newSelf = self
        newSelf.scrollAction = action
        newSelf.scrollActionBegan = onBegan
        newSelf.scrollActionEnded = onEnded
        newSelf.scrollActionCancelled = onCancelled
        return newSelf
    }
}
#endif
