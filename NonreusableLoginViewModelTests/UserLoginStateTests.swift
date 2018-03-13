//
//  UserLoginStateTests.swift
//  NonreusableLoginViewModelTests
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import XCTest
@testable import NonreusableLoginViewModel

class UserLoginStateTests: XCTestCase {
    
    func testLoggedIn() {
        let userLoginState = UserLoginState(userName: "user1", email: "user1@users.com", phone: "123456789")
        XCTAssertEqual(userLoginState.isLoggedIn, true)
        XCTAssertEqual(userLoginState.user, User(userName: "user1", email: "user1@users.com", phone: "123456789"))
        XCTAssertEqual(userLoginState.error, nil)
    }
    
    func testErrornousLogIn() {
        let err = NSError.init()
        let userLoginState = UserLoginState(error: err)
        XCTAssertEqual(userLoginState.isLoggedIn, false)
        XCTAssertEqual(userLoginState.user, nil)
        XCTAssertEqual(userLoginState.error, err)
    }
    
    func testEmptyState() {
        let userLoginState = UserLoginState()
        XCTAssertEqual(userLoginState.isLoggedIn, false)
        XCTAssertEqual(userLoginState.user, nil)
        XCTAssertEqual(userLoginState.error, nil)
    }
}
