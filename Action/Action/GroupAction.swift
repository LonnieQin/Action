
import Foundation

/// Execute actions concomitantly,when each action is finished shouldFinish block will be invoked to decide if this GroupAction is finished. We usually decide whether this action is finished by checking the complete status of actions
open class GroupAction:Action {
    
    /// Action array
    private let actions:NSArray
    
    /// a block to determine if this action is finished
    open let shouldFinishBlock:([Action])->Bool
    
    /// init
    ///
    /// - Parameters:
    ///   - actions: Actions
    ///   - shouldFinish:  determine if this action is finished
    public init(_ actions:Action...,shouldFinish:@escaping ([Action])->Bool) {
        self.actions = NSArray(array: actions)
        self.shouldFinishBlock = shouldFinish
        super.init()
        //Monitor these actions
        self.actions.addObserver(self, toObjectsAt: IndexSet(integersIn:0..<self.actions.count), forKeyPath: "finished", options: .new, context: nil)
    }
    
    /// init
    ///
    /// - Parameters:
    ///   - actions: Actions
    ///   - shouldFinish:  determine if this action is finished
    public init(_ actions:[Action],shouldFinish:@escaping ([Action])->Bool) {
        self.actions = NSArray(array: actions)
        self.shouldFinishBlock = shouldFinish
        super.init()
        //Monitor these actions
        self.actions.addObserver(self, toObjectsAt: IndexSet(integersIn:0..<self.actions.count), forKeyPath: "finished", options: .new, context: nil)
    }
    
    override open func execute() {
        self.actions.forEach { (action) in
            (action as! Action).execute()
        }
    }
    
    override open func cancel() {
        super.cancel()
        actions.forEach { (action) in
            (action as! Action).cancel()
        }
    }
    
    override open func finish() {
        
        if finished == false {
            finished = true
            actions.forEach { (action) in
                if (action as! Action).finished == false {
                    (action as! Action).finish()
                }
            }
        }
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //When action is finished,this code will be executed to determine if this group action is finished.
        if shouldFinishBlock(self.actions as! [Action]) && finished == false && canceled == false{
            finish()
        }
    }
    deinit {
        self.actions.removeObserver(self, fromObjectsAt: IndexSet(integersIn:0..<self.actions.count), forKeyPath: "finished")
    }
}


/// This function creates one group action.When two action is all finished,this action is finished.
///
/// - Parameters:
///   - action1: action1
///   - action2: action2
/// - Returns: GroupAction
public func && (action1:Action,action2:Action)->GroupAction {
    return GroupAction(action1,action2,shouldFinish:{$0[0].finished && $0[1].finished})
}
/// This function creates one group action.if any sub action is finished,this action is finished.
///
/// - Parameters:
///   - action1: action1
///   - action2: action2
/// - Returns: GroupAction
public func || (action1:Action,action2:Action)->GroupAction  {
    return GroupAction(action1,action2,shouldFinish:{$0[0].finished || $0[1].finished})
}
prefix func ! (action:Action)->GroupAction  {
    return GroupAction(action,shouldFinish:{!$0[0].finished})
}

prefix operator ✓
prefix func ✓ (action:Action)->GroupAction  {
    return GroupAction(action,shouldFinish:{_ in true})
}
prefix operator ✕
prefix func ✕ (action:Action)->GroupAction  {
    return GroupAction(action,shouldFinish:{_ in false})
}

extension Action {
    open func and(_ action:Action)->Action {
        return self && action
    }
    open func or(_ action:Action)->Action {
        return self || action
    }

    open func not()->Action {
        return !self
    }

    open func yes()->Action {
        return ✓self
    }
    open func no()->Action {
        return ✕self
    }
    
    static open func and(_ action1:Action,_ action2:Action)->Action {
        return action1 && action2
    }
    static open func or(_ action1:Action,_ action2:Action)->Action {
        return action1 || action2
    }
    static open func not(_ action:Action)->Action {
        return !action
    }
    static open func yes(_ action:Action)->Action {
        return ✓action
    }
    static open func no(_ action:Action)->Action {
        return ✕action
    }
}
