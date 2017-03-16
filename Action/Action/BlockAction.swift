
import Foundation

/// Execute the contents of the block,you can decide when to finish the action
class BlockAction:Action {
    var block:(BlockAction)->Void = {(action) in
    
    }
    init(block:@escaping (BlockAction)->Void) {
        self.block = block
        super.init()
    }
    
    override func execute(){
        block(self)
    }
    
    override func stop() {
        finished = true
    }
}
