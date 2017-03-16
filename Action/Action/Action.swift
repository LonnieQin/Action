
import Foundation

/// This is the base class of actions,do nothing
class Action:NSObject {
    /// is Canceled
    dynamic var canceled:Bool = false

    /// is Finished
    dynamic var finished:Bool = false
 
    /// Execute
    func execute(){
        
    }
    
    /// Stop
    func stop() {
    
    }
    
    /// Cancel
    func cancel() {
    
    }
}
