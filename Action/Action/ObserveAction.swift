
import Foundation

/// 对某个对象的KVO的Action,执行的时候添加自己为观察者，当接收到通知的时候移除观察者。Action结束。
open class ObserveAction:Action {
    open weak var object:NSObject?
    open var keypath:String
    open var isAdded = false
    open var change:[NSKeyValueChangeKey:Any]?
    public init(object:NSObject,keypath:String) {
        self.object = object
        self.keypath = keypath
        super.init()
    }
    
    override open func execute() {
        if isAdded == false {
            isAdded = true
            object!.addObserver(self, forKeyPath: keypath, options: .new, context: nil)
        }
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.change = change
        finish()
    }
    override open func finish() {
        finished = true
        if isAdded {
            isAdded = false
            object!.removeObserver(self, forKeyPath: keypath)
        }
    }
    override open func cancel() {
        canceled = true
        if isAdded {
            isAdded = false
            object!.removeObserver(self, forKeyPath: keypath)
        }
    }
    
}
