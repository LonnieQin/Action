
import Foundation

/// This is the base class of actions,do nothing
open class Action:NSObject {
    /// is Canceled
    open dynamic var canceled:Bool = false
    /// is Finished
    open dynamic var finished:Bool = false
    /// is executing
    open dynamic var executing:Bool = false
    
    /// Execute
    open func execute(){
        
    }
    
    /// Stop
    open func finish() {
        
    }
    
    /// Cancel
    open func cancel() {
        
    }
}


extension Action {
    
    /// Custom Action
    ///
    /// - Parameter block: Block of code
    /// - Returns: Custom Action
    static open func custom(_ block:@escaping (BlockAction)->Void)->Action {
        return BlockAction(block: block)
    }
    
    /// Sequence Action
    ///
    /// - Parameter actions: Sequence
    /// - Returns: Sequence Action
    static open func sequence(_ actions:[Action])->Action {
        let sequence = SequenceAction()
        actions.forEach { (action) in
            sequence.addAction(action: action)
        }
        return sequence
    }
    
    /// Group Action
    ///
    /// - Parameters:
    ///   - actions: Actions
    ///   - shouldFinish: Decide If we should finish this action
    /// - Returns: Group Action
    static open func group(_ actions:[Action],shouldFinish:@escaping ([Action])->Bool)->Action {
        let group = GroupAction(actions, shouldFinish: shouldFinish)
        return group
    }
    
    
    /// Delay
    ///
    /// - Parameter duration: Duration
    /// - Returns: An Action That Delay duration sections
    static open func delay(duration:TimeInterval)->Action {
        return Action.custom({ (action) in
            DispatchQueue.main.asyncAfter(deadline: .now()+duration, execute: {
                if !action.canceled {
                    action.finish()
                }
            })
        })
    }
}
