
import Foundation

/// 顺序执行多个Action，最后一个Action执行完的时候结束
open class SequenceAction:Action{
    var actions:[Action] = []
    var selectedIndex = 0
    public init(_ actions:Action...) {
        self.actions = actions
        super.init()
        //Add Notifications
        if self.actions.count > 0 {
            (actions as NSArray).addObserver(self, toObjectsAt: IndexSet(integersIn:0..<self.actions.count), forKeyPath: "finished", options: .new, context: nil)
        }
    }
    
    public init(_ actions:[Action]) {
        self.actions = actions
        super.init()
        //Add Notifications
        if self.actions.count > 0 {
            (actions as NSArray).addObserver(self, toObjectsAt: IndexSet(integersIn:0..<self.actions.count), forKeyPath: "finished", options: .new, context: nil)
        }
    }
    
    open func addAction(action:Action) {
        actions.append(action)
        action.addObserver(self, forKeyPath: "finished", options: .new, context: nil)
    }
    
    override open func execute() {
        actions[selectedIndex].execute()
    }
    override open func cancel() {
        super.cancel()
        actions[selectedIndex].cancel()
    }
    
    override open func finish() {
        if finished == false {
            finished = true
            if actions[selectedIndex].finished == false {
                actions[selectedIndex].finish()
            }
        }
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let index = actions.index(of: object as! Action)
        if index == actions.count-1 {
            finish()
        } else {
            selectedIndex += 1
            actions[selectedIndex].execute()
        }
    }
    deinit {
        (self.actions as NSArray).removeObserver(self, fromObjectsAt: IndexSet(integersIn:0..<self.actions.count), forKeyPath: "finished")
    }
} 
func >> (action1:Action,action2:Action)->SequenceAction {
    return SequenceAction(action1,action2)
}
