
import Foundation

/// Execute the contents of the block,you can decide when to finish the action
open class BlockAction:Action {
    open var block:(BlockAction)->Void = {(action) in
    
    }
    public init(block:@escaping (BlockAction)->Void) {
        self.block = block
        super.init()
    }
    
    open override func execute(){
        block(self)
    }
    
    override func finish() {
        finished = true
    }
    override func cancel() {
        canceled = true
    }
}
