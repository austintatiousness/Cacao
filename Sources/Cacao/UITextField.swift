///Written by Austin Clow

import struct Foundation.CGFloat
import struct Foundation.CGPoint
import struct Foundation.CGSize
import struct Foundation.CGRect
import struct Foundation.TimeInterval
import Silica

/// A control that allows for Text input.
///
/// The `UISwitch` class declares a property and a method to control its on/off state.
open class UITextField: UIControl {

    // MARK: - Initialization
    
    var focused: Bool = false {
    	didSet {
    		if self.focused {
    		self.backgroundColor = .red
    		} else {
    		self.backgroundColor = .white
    		}
    		
    	}
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // disable user interaction
        self.isUserInteractionEnabled = true
    }

	open override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
       	 print("presses began with")
       	 if let event = event {
       	 	self.text = self.text! + event.characters
       	 	print(self.text!)
       	 }
    	}
    	
    	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    		print("becoming first responder.")
    		self.becomeFirstResponder()
    		self.focused = true
    		
    	}
    	


	open var text: String? = "1" { didSet { setNeedsDisplay() } }
	
	open var font: UIFont = UIFont(name: "Helvetica", size: 17)! { didSet { setNeedsDisplay() } }
    
    	open var textColor: UIColor = .black { didSet { setNeedsDisplay() } }
    
    	open var textAlignment: TextAlignment = .left { didSet { setNeedsDisplay() } }
	
	open override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext()
            else { return }
        
        var attributes = TextAttributes()
        attributes.font = font
        attributes.color = textColor
        attributes.paragraphStyle.alignment = textAlignment
        
        text?.draw(in: self.bounds, context: context, attributes: attributes)
    }
}
