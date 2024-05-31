//
//  TrackpadPanGesture.swift
//  SlidingRulerXcode
//
//  Created by Cyril Zakka on 5/31/24.
//

import SwiftUI

protocol ScrollViewDelegateProtocol {
    /// Informs the receiver that the mouse’s scroll wheel has moved.
    func scrollWheel(with event: NSEvent)
    func scrollWheelDidBegin(with event: NSEvent)
    func scrollWheelDidEnd(with event: NSEvent)
    func scrollWheelDidCancel(with event: NSEvent)
}

class WrappedScrollView: NSView {
    /// Connection to the SwiftUI view that serves as the interface to our AppKit view.
    var delegate: ScrollViewDelegateProtocol!
    /// Let the responder chain know we will respond to events.
    override var acceptsFirstResponder: Bool { true }
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
