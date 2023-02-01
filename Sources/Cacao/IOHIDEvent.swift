//
//  IOHIDEvent.swift
//  Cacao
//
//  Created by Alsey Coleman Miller on 11/24/17.
//

import Foundation
import CSDL2
import SDL

internal struct IOHIDEvent {
    
    let timestamp: UInt
    
    static var textInputCapturing: Bool = false
    
    private(set) var data: Data
    
    init?(sdlEvent: inout SDL_Event) {
        
        self.timestamp = UInt(sdlEvent.common.timestamp)
        
        let eventType = SDL_EventType(rawValue: sdlEvent.type)
        
        switch eventType {
            
        case SDL_QUIT,
             SDL_APP_TERMINATING:
            
            self.data = .quit
            
        case SDL_FINGERDOWN,
             SDL_FINGERUP,
             SDL_FINGERMOTION:
            let screenEvent: ScreenInputEvent
            
            switch eventType {
            case SDL_FINGERDOWN: screenEvent = .down
            case SDL_FINGERUP: screenEvent = .up
            case SDL_FINGERMOTION: screenEvent = .motion
            default: return nil
            }
            
            let screenLocation = CGPoint(x: CGFloat(sdlEvent.button.x),
                                         y: CGFloat(sdlEvent.button.y))
            
            self.data = .touch(screenEvent, screenLocation)
            
        case SDL_MOUSEBUTTONDOWN,
             SDL_MOUSEBUTTONUP,
             SDL_MOUSEMOTION:
            // dont translate touch screen events.
            guard sdlEvent.button.which != Uint32(bitPattern: -1)
                else { return nil }
            
            let screenEvent: ScreenInputEvent
            
            switch eventType {
            case SDL_MOUSEBUTTONDOWN: screenEvent = .down
            case SDL_MOUSEBUTTONUP: screenEvent = .up
            case SDL_MOUSEMOTION: screenEvent = .motion
            default: return nil
            }
            
            let screenLocation = CGPoint(x: CGFloat(sdlEvent.button.x),
                                         y: CGFloat(sdlEvent.button.y))
            
            self.data = .mouse(screenEvent, screenLocation)
            
        case SDL_MOUSEWHEEL:
            
            let translation = CGSize(width: CGFloat(sdlEvent.wheel.x),
                                     height: CGFloat(sdlEvent.wheel.y))
            
            self.data = .mouseWheel(translation)
            
        case SDL_WINDOWEVENT:
            
            let sdlWindowEvent = SDL_WindowEventID(rawValue: SDL_WindowEventID.RawValue(sdlEvent.window.event))
            
            let windowEvent: WindowEvent
            
            switch sdlWindowEvent {
            case SDL_WINDOWEVENT_SIZE_CHANGED: windowEvent = .sizeChange
            case SDL_WINDOWEVENT_FOCUS_GAINED,
                 SDL_WINDOWEVENT_FOCUS_LOST: windowEvent = .focusChange
            default: return nil
            }
            
            self.data = .window(windowEvent)
            
        case SDL_APP_LOWMEMORY:
            
            self.data = .lowMemory
            
        case SDL_TEXTINPUT: 
        
        
        let state: KeyState
        state = .pressed
	print("Len: \(sdlEvent.edit.length)")
        let textAsString = withUnsafeBytes(of: &sdlEvent.text.text) { (rawPtr) -> String in
    			let ptr = rawPtr.baseAddress!.assumingMemoryBound(to: UInt8.self)
    			let data = Foundation.Data(bytes: ptr, count: 4)
    			if let string = String(data: data, encoding: .utf8) {
    				return string
    			}
    			return "ERROR"
    			//load(fromByteOffset: 8, as: CChar.self)
    			//assumingMemoryBound(to: CChar.self)
   			// return String(cString: ptr)
	}		
        print("key: '\(textAsString)'")
           	 
            
        
         self.data = .composingKey(string: textAsString, finished: true)
        case SDL_KEYUP,
             SDL_KEYDOWN:
            
            let state: KeyState
            //MOD 1 == shift, MOD 2 == right shift
            switch Int32(sdlEvent.key.state) {
                
            case SDL_PRESSED:
                state = .pressed
                
            case SDL_RELEASED:
                state = .released
                
            default:
		fatalError("Invalid key state \(sdlEvent.key.state)")
            }

            var shift: Bool = sdlEvent.key.keysym.mod == 1

            self.data = .keyDown(state, sdlEvent.key.keysym.scancode.rawValue, [.none], IOHIDEvent.keyCodeToString(Int(sdlEvent.key.keysym.sym), shift: shift))

            IOHIDEvent.textInputCapturing = false
            
        default:
            print("unhandled type\(eventType)")
            return nil
        }
    }
    
    public static func keyCodeToString(_ keyCode: Int, shift: Bool) -> String? {
    	if keyCode == 13 {
    		return "\n"
    	} else if keyCode == 32 {
    		return " "
    	} else if keyCode == 9 {
    		return "\t"
    	} else if keyCode == 97 {
    		return shift ? "A" : "a"
    	} else if keyCode == 98 {
    		return shift ? "B" : "b"
    	} else if keyCode == 99 {
    		return shift ? "C" : "c"
    	} else if keyCode == 100 {
    		return shift ? "D" : "d"
    	} else if keyCode == 101 {
    		return shift ? "E" : "e"
    	} else if keyCode == 102 {
    		return shift ? "F" : "f"
    	} else if keyCode == 103 {
    		return shift ? "G" : "g"
    	} else if keyCode == 104 {
    		return shift ? "H" : "h"
    	} else if keyCode == 105 {
    		return shift ? "I" : "i"
    	} else if keyCode == 106 {
    		return shift ? "J" : "j"
    	} else if keyCode == 107 {
    		return shift ? "K" : "k"
    	} else if keyCode == 108 {
    		return shift ? "L" : "l"
    	} else if keyCode == 109 {
    		return shift ? "M" : "m"
    	} else if keyCode == 110 {
    		return shift ? "N" : "n"
    	} else if keyCode == 111 {
    		return shift ? "O" : "o"
    	} else if keyCode == 112 {
    		return shift ? "P" : "p"
    	} else if keyCode == 113 {
    		return shift ? "Q" : "q"
    	} else if keyCode == 114 {
    		return shift ? "R" : "r"
    	} else if keyCode == 115 {
    		return shift ? "S" : "s"
    	} else if keyCode == 116 {
    		return shift ? "T" : "t"
    	} else if keyCode == 117 {
    		return shift ? "U" : "u"
    	} else if keyCode == 118 {
    		return shift ? "V" : "v"
    	} else if keyCode == 119 {
    		return shift ? "W" : "w"
    	} else if keyCode == 120 {
    		return shift ? "X" : "x"
    	} else if keyCode == 121 {
    		return shift ? "Y" : "y"
    	} else if keyCode == 122 {
    		return shift ? "Z" : "z"
    	}
    	return nil
    }
    
    /// Merge the data if an event into another
    func merge(event: IOHIDEvent) -> IOHIDEvent? {
        
        switch (self.data, event.data) {
            
        case (.quit, .quit):
            return event
            
        case let (.touch(lhsEvent, _), .touch(rhsEvent, _)):
            return lhsEvent == rhsEvent ? event : nil
            
        case let (.mouse(lhsEvent, _), .mouse(rhsEvent, _)):
            return lhsEvent == rhsEvent ? event : nil
            
        case (.window(_), .window(_)):
            return nil
            
        case let (.mouseWheel(lhsTranslation), .mouseWheel(rhsTranslation)):
            
            var mergedEvent = event
            
            let size = CGSize(width: lhsTranslation.width + rhsTranslation.width,
                              height: lhsTranslation.height + rhsTranslation.height)
            
            // update data
            mergedEvent.data = .mouseWheel(size)
            
            return mergedEvent
            
        default:
            
            return nil
        }
    }
}

internal extension IOHIDEvent {
    
    enum Data {
        
        case quit
        case mouse(ScreenInputEvent, CGPoint)
        case mouseWheel(CGSize)
        case touch(ScreenInputEvent, CGPoint)
        case window(WindowEvent)
        case keyDown(KeyState, UInt32?, [ModificationKey], String?)
        case composingKey(string: String, finished: Bool)
        case lowMemory
    }
    
    enum ScreenInputEvent {
        
        case down
        case up
        case motion
    }
    
    enum WindowEvent {
        
        case sizeChange
        case focusChange
    }
    
    enum KeyState {
        
        case pressed
        case released
    }
    
    struct ModificationKey: OptionSet {
    	let rawValue: Int
    	static var none = ModificationKey(rawValue: 1 << 0)
        static var leftShift = ModificationKey(rawValue: 1 << 1)
        static var rightShift = ModificationKey(rawValue: 1 << 2)
        static var controlKey = ModificationKey(rawValue: 1 << 3)
        static var optionKey = ModificationKey(rawValue: 1 << 4)
        static var logoKey = ModificationKey(rawValue: 1 << 5)
    }
}
