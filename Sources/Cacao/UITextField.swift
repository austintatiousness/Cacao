import struct Foundation.CGFloat
import struct Foundation.CGPoint
import struct Foundation.CGSize
import struct Foundation.CGRect
import struct Foundation.TimeInterval
import Silica

/// A control that offers a binary choice, such as On/Off.
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
       	 if let event = event, let first = event.characters.first, var text = self.text {
       	 	if self.insertionPoint_ == text.count {
       	 		self.text = text + "\(first)"
       	 		insertionPoint_ = self.text!.count
       	 	} else {
       	 		text.insert(first, at: text.index(text.startIndex, offsetBy: self.insertionPoint_))
				self.insertionPoint_ += 1
       	 		self.text = text
       	 	}
       	 	
       	 }
    	}
    	
    	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    		self.becomeFirstResponder()
    		self.focused = true
    		self.insertionPoint_ = 0
    		
    	}
    	
	private var insertionPoint_: Int = 0
	private var insertionLength_: Int = 0

	open var text: String? = "" { didSet { setNeedsDisplay() } }
	
	open var font: UIFont = UIFont(name: "Helvetica", size: 28)! { didSet { setNeedsDisplay() } }
    
    	open var textColor: UIColor = .black { didSet { setNeedsDisplay() } }
    
    	open var textAlignment: TextAlignment = .left { didSet { setNeedsDisplay() } }
	
	open override func draw(_ rect: CGRect) {
        	guard let context = UIGraphicsGetCurrentContext() else { return }
        	var attributes = TextAttributes()
        	attributes.font = font
        	attributes.color = textColor
        	attributes.paragraphStyle.alignment = textAlignment
        	text?.draw(in: self.bounds, context: context, attributes: attributes)
    }
}
