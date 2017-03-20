
import Foundation

/// This is the base class of actions,do nothing
open class Action:NSObject {
    /// is Canceled
    open dynamic var canceled:Bool = false

    /// is Finished
    open dynamic var finished:Bool = false
 
    /// Execute
    open func execute(){
        
    }
    
    /// Stop
    open func stop() {
    
    }
    
    /// Cancel
    open func cancel() {
    
    }
}
