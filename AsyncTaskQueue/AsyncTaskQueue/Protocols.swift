//
//  TaskQueue.swift
//  AsyncTaskQueue
//
//  Created by Bruno Werminghoff on 29/08/17.
//  Copyright © 2017 Bruno Werminghoff. All rights reserved.
//

import Foundation

// MARK: - Events notifications
public protocol AsyncEventListenerProtocol : AnyObject {
    // implement your own "subprotocol"
}

// MARK: - Tasks
public protocol AsyncTaskProtocol : AnyObject {
    
    func getDate() -> Date
    func execute(completion: @escaping ((Bool) -> Void)) -> Void
    func store() -> Void
    func delete() -> Void
    func setFinished() -> Void
    func isFinished() -> Bool
    func notifyFinished(listener: AsyncEventListenerProtocol) -> Void
    
    static func load() -> [AsyncTaskProtocol]
}

// MARK: - Queue
public protocol AsyncTaskQueueProtocol : AnyObject {
    
    func add(listener: AsyncEventListenerProtocol) -> Void
    func remove(listener: AsyncEventListenerProtocol) -> Void
    
    func append(_ task: AsyncTaskProtocol) -> Void
    
}

// MARK: - Storage
public protocol AsyncTaskQueueStorageProtocol : AnyObject {
    
    func add(_ task: AsyncTaskProtocol) -> Void
    func peek() -> AsyncTaskProtocol?
    @discardableResult func remove() -> AsyncTaskProtocol?
    func load<T : AsyncTaskProtocol>(_ taskType : T.Type) -> Void
    
}
