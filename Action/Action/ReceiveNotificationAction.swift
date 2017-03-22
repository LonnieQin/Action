import Foundation
/// Rece，执行的时候加通知到NotificationCenter接收到通知后移除通知，Action结束
class ReceiveNotificationAction: Action {
    var name:String
    var handler:(Notification)->Void
    var notification:Notification?
    fileprivate var addNotificaion:Bool = false
    
    
    /// 初始化参数
    init(name:String,handler:@escaping (Notification)->Void = {_ in }) {
        self.name = name
        self.handler = handler
        super.init()
    }
    
    override func execute() {
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveNotificationAction.onReceiveNotification(notification:)), name: Notification.Name(name), object: nil)
        addNotificaion = true
    }
    
    func onReceiveNotification(notification:Notification) {
        if finished == false && canceled == false{
            self.notification = notification
            handler(notification)
            finished = true
        }
    }
    
    override func cancel() {
        super.cancel()
        if addNotificaion == true {
            NotificationCenter.default.removeObserver(self)
            addNotificaion = false
        }
    }
    
    override func finish() {
        if addNotificaion == true {
            NotificationCenter.default.removeObserver(self)
            addNotificaion = false
        }
    }
}
