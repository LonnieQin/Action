//
//  ActionTests.swift
//  ActionTests
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import XCTest
@testable import Action

class ActionTests: XCTestCase {
    
    func testBlockAction() {
        let action = BlockAction {
            print("Hello world")
            $0.finish()
        }
        action.execute()
    }
    
    func testSequenceAction() {
        let sequence = Action.sequence(
        .custom {
            print("1")
            $0.finish()
        },
        .custom {
            print("2")
            $0.finish()
        },
        .custom {
            print("3")
            $0.finish()
        })
        sequence.execute()
    }
    
    func testGroupAction() {
        let action1 = Action.custom { (action) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                print("Block Action 1")
                action.finish()
            })
        }
        let action2 = Action.custom { (action) in
            print("Block Action 2")
            action.finish()
        }
 
        //action1 or action2 finish will finish this action
        (action1 || action2).execute()
        action1.finished = false
        action2.finished = false
        //Action1 and action2 finish will finish this action
        (action1 && action2).execute()
    }
}
