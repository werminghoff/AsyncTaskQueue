//
//  AsyncTaskQueue.swift
//  AsyncTaskQueue
//
//  Created by Bruno Werminghoff on 29/08/17.
//  Copyright © 2017 Bruno Werminghoff. All rights reserved.
//

import Foundation

public class AsyncTaskQueue : NSObject, AsyncTaskQueueStorageProtocol, AsyncTaskQueueProtocol {
    
    public static let `default` = AsyncTaskQueue()
    var retryDelay : TimeInterval = 5.0
    
    private let queue = DispatchQueue(label: "AsyncTaskQueue.dispatch_queue")
    private var tasks : [AsyncTaskProtocol] = []
    private var listeners : [AsyncEventListenerProtocol] = []
    private var running = false
    
    // MARK: - Storage
    public func add(_ task: AsyncTaskProtocol) -> Void {
        queue.async {
            task.store()
            self.tasks.append(task)
        }
        self.run()
    }
    
    @discardableResult
    public func remove() -> AsyncTaskProtocol? {
        var task : AsyncTaskProtocol? = nil
        queue.sync {
            task = tasks.remove(at: 0)
            task?.delete()
        }
        return task
    }
    
    public func peek() -> AsyncTaskProtocol? {
        
        return tasks.first
        
    }
    
    public func load<T : AsyncTaskProtocol>(_ taskType : T.Type) -> Void {
        
        queue.async {
            
            let all_tasks = taskType.load()
            for task in all_tasks {
                self.tasks.append(task)
            }
            
            self.tasks.sort(by: { (a, b) -> Bool in
                return a.getDate() < b.getDate()
            })
            
        }
        
    }
    
    // MARK: - Queue
    public func add(listener: AsyncEventListenerProtocol) -> Void{
        queue.async {
            self.listeners.append(listener)
        }
    }
    
    public func remove(listener: AsyncEventListenerProtocol) -> Void {
        queue.async {
            
            let idx = self.listeners.index(where: { (i) -> Bool in
                return i === listener
            })
            
            if let idx = idx {
                self.listeners.remove(at: idx)
            }
            
        }
    }
    
    public func append(_ task: AsyncTaskProtocol) -> Void {
        
        self.add(task)
        self.run()
        
    }
    
    private func runNext() -> Void {
        
        queue.async {
            
            if let task = self.peek() {
                
                task.execute(completion: { (finished) in
                    
                    if finished {
                        
                        NSLog("Async task executed successfully!")
                        
                        assert(self.peek() != nil)
                        task.setFinished()
                        for listener in self.listeners {
                            task.notifyFinished(listener: listener)
                        }
                        self.remove()
                        self.runNext()
                        
                    }
                    else{
                        
                        NSLog("Async task failed to execute...")
                        
                        self.queue.asyncAfter(deadline: DispatchTime.now() + self.retryDelay, execute: {
                            assert(self.peek() != nil)
                            self.runNext()
                        })
                        
                    }
                    
                })
                
            }
            else{
                self.running = false
            }
            
        }
        
    }
    
    func run() -> Void {
        queue.async {
            
            if self.running {
                return
            }
            self.running = true
            
            self.runNext()
            
        }
    }
}
