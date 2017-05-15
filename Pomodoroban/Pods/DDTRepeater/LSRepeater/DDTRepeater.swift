import Foundation

public typealias DDTRepeatClosure = () -> Void

// we need to subclass NSObject, as NSTimer uses the runtime for method invocation
open class DDTRepeater: NSObject {
    
    var timer:Timer!
    var execute:DDTRepeatClosure!
    
    
    open class func repeater(_ interval:TimeInterval, fireOnceInstantly:Bool, execute: @escaping DDTRepeatClosure) -> DDTRepeater {
        
        let repeater = DDTRepeater()
        repeater.execute = execute
        
        repeater.timer = Timer.scheduledTimer(timeInterval: interval, target:repeater, selector: #selector(DDTRepeater.timerDidFire), userInfo: nil, repeats: true)
        
        if fireOnceInstantly {
            repeater.timerDidFire()
        }
        
        return repeater
    }
    
    open class func repeater(_ interval:TimeInterval, execute: @escaping DDTRepeatClosure) -> DDTRepeater {
        return self.repeater(interval, fireOnceInstantly: true, execute: execute)
    }
    
    open func invalidate()
    {
        self.timer.invalidate()
    }
    
    func timerDidFire() {
        self.execute()
    }
    
}
