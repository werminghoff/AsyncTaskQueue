//
//  DelayedTask.swift
//  Example-InMemoryStorage
//
//  Created by Bruno Werminghoff on 29/08/17.
//  Copyright © 2017 Bruno Werminghoff. All rights reserved.
//

import UIKit
import AsyncTaskQueue

protocol DelayedTaskListenerProtocol : AsyncEventListenerProtocol {
    func delayedTaskDidFinish(_ task: DelayedTask)
}

class DelayedTask : NSObject, AsyncTaskProtocol {
    
    private let date = Date()
    private var finished : Bool = false
    var taskDidFinish : (()->Void)? = nil
    var delay : TimeInterval = 0.1
    func getDate() -> Date {
        return date
    }
    
    // Not implemented in this example as everything is kept in memory only
    func store() -> Void { }
    func delete() -> Void { }
    
    func execute(completion: @escaping ((Bool) -> Void)) -> Void {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.delay) { 
            
            // Randomize success rate, should be enough to fake a few "failures"
            let success = (arc4random() % 3) == 0
            
            if success {
                self.taskDidFinish?()
            }
            
            completion(success)
            
        }
        
    }
    
    func setFinished() -> Void {
        self.finished = true
    }
    func isFinished() -> Bool {
        return self.finished
    }
    
    func notifyFinished(listener: AsyncEventListenerProtocol) -> Void {
        (listener as? DelayedTaskListenerProtocol)?.delayedTaskDidFinish(self)
    }
    
    static func load() -> [AsyncTaskProtocol]{
        return []
    }
}
