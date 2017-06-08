//
//  UIEvent.swift
//  Cacao
//
//  Created by Alsey Coleman Miller on 6/7/17.
//

import typealias Foundation.TimeInterval
import class Foundation.ProcessInfo

/// An object that describes a single user interaction with your app.
public final class UIEvent {
    
    // MARK: - Getting the Touches for an Event
    
    /// Returns all touches associated with the event.
    ///
    /// - Returns: A set of `UITouch` objects representing all touches associated with the event.
    public internal(set) var allTouches: Set<UITouch>? = []
    
    public func touches(for view: UIView) -> Set<UITouch>? {
        
        return allTouches?.filter({ $0.view === view })
    }
    
    public func touches(for window: UIWindow) -> Set<UITouch>? {
        
        return allTouches?.filter({ $0.window === window })
    }
    
    public func touches(for gestureRecognizer: UIGestureRecognizer) -> Set<UITouch>? {
        
        return allTouches?.filter({ $0.gestureRecognizers?.contains(where: { $0 === gestureRecognizer }) ?? false })
    }
    
    // MARK: - Getting Event Attributes
    
    /// The time when the event occurred.
    ///
    /// This property contains the number of seconds that have elapsed since system startup.
    /// For a description of this time value, see the description of the `systemUptime` method of the `ProcessInfo` class.
    public let timestamp: TimeInterval
    
    // MARK: - Getting the Event Type
    
    /// Returns the type of the event.
    ///
    /// The UIEventType constant returned by this property indicates the general type of this event—for example,
    /// whether it is a touch or motion event.
    public let type: UIEventType = .touches
    
    /// Returns the subtype of the event.
    ///
    /// The `UIEventSubtype` constant returned by this property indicates the subtype of the event
    /// in relation to the general type, which is returned from the type property.
    public let subtype: UIEventSubtype = .none
    
    // MARK: - Initialization
    
    internal init() {
        
        self.timestamp = ProcessInfo.processInfo.systemUptime
    }
}

public enum UIEventType: Int {
    
    /// The event is related to touches on the screen.
    case touches
    
    /// The event is related to motion of the device, such as when the user shakes it.
    case motion
    
    /// The event is a remote-control event. Remote-control events originate as commands received from a headset or external accessory for the purposes of controlling multimedia on the device.
    case remoteControl
    
    /// The event is related to the press of a physical button.
    case presses
}

public enum UIEventSubtype: Int {
    
    case none
}
