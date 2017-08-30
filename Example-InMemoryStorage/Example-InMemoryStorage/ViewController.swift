//
//  ViewController.swift
//  Example-InMemoryStorage
//
//  Created by Bruno Werminghoff on 29/08/17.
//  Copyright © 2017 Bruno Werminghoff. All rights reserved.
//

import UIKit
import AsyncTaskQueue

class ViewController: UIViewController, DelayedTaskListenerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.runSampleTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AsyncTaskQueue.default.add(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AsyncTaskQueue.default.remove(listener: self)
    }

    func runSampleTasks() {
        let test_a = DelayedTask()
        test_a.taskDidFinish = {
            NSLog("TaskA finished!");
        }
        test_a.delay = 0.1
        
        let test_b = DelayedTask()
        test_b.taskDidFinish = {
            NSLog("TaskB finished!");
        }
        test_b.delay = 0.15
        
        let test_c = DelayedTask()
        test_c.taskDidFinish = {
            NSLog("TaskC finished!");
        }
        test_c.delay = 0.25
        
        let test_d = DelayedTask()
        test_d.taskDidFinish = {
            NSLog("TaskD finished!");
        }
        test_d.delay = 0.0
        
        let queue = AsyncTaskQueue.default
        queue.add(test_a)
        queue.add(test_b)
        queue.add(test_c)
        queue.add(test_d)
    }

    func delayedTaskDidFinish(_ task: DelayedTask) {
        NSLog("Task finished - delegate")
    }

}

