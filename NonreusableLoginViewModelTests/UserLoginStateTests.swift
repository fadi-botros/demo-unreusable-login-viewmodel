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
        XCTAssertNotEqual(userLoginState.user, User(userName: "user2", email: "user1@users.com", phone: "123456789"))
        XCTAssertNotEqual(userLoginState.user, User(userName: "user2", email: "user2@users.com", phone: "123456789"))
        XCTAssertNotEqual(userLoginState.user, User(userName: "user2", email: "user2@users.com", phone: "123456781"))
        XCTAssertNil(userLoginState.error)
    }
    
    func testErrornousLogIn() {
        let err = NSError.init(domain: "a", code: 1, userInfo: nil)
        let userLoginState = UserLoginState(error: err)
        XCTAssertEqual(userLoginState.isLoggedIn, false)
        XCTAssertNil(userLoginState.user)
        XCTAssert(userLoginState.error! as NSError == err)
    }
    
    func testEmptyState() {
        let userLoginState = UserLoginState()
        XCTAssertEqual(userLoginState.isLoggedIn, false)
        XCTAssertNil(userLoginState.user)
        XCTAssertNil(userLoginState.error)
    }
}
