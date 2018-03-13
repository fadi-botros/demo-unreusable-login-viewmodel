//
//  LoginViewModelTests.swift
//  NonreusableLoginViewModelTests
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import XCTest
@testable import NonreusableLoginViewModel

class FakeLoginRepository: LoginRepository {
    func login(userName: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            if userName == "firstUser" && password == "firstPass" {
                completion(User(userName: "firstUser", email: "user1@users.com", phone: "12345678"), nil)
            } else if userName == "secondUser" && password == "secondPass" {
                completion(User(userName: "secondUser", email: "user2@users.com", phone: "87654321"), nil)
            } else {
                completion(nil, LoginRepositoryUtil.errorFactory(100))
            }
        }
    }
}

class MockLoginRepositoryThatReturnsNetworkError: LoginRepository {
    func login(userName: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
            completion(nil, NSError.init(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil))
        }
    }
}

class LoginViewModelTests: XCTestCase {
    
    var fakeRepository: FakeLoginRepository?
    var mockRepositoryReturningError: MockLoginRepositoryThatReturnsNetworkError?
    
    override func setUp() {
        fakeRepository = FakeLoginRepository()
        mockRepositoryReturningError = MockLoginRepositoryThatReturnsNetworkError()
    }
    
    private func commonLoginTest(todoWithViewModel: (LoginViewModel) -> (),
                                 then: (LoginViewModel) -> ()) {
        let loginViewModel = LoginViewModel()
        let loginStateExpectation = XCTKVOExpectation(keyPath: "loginState", object: loginViewModel)
        todoWithViewModel(loginViewModel)
        wait(for: [loginStateExpectation], timeout: 1)
        then(loginViewModel)
    }
    
    func testSuccessfulLogin() {
        commonLoginTest(todoWithViewModel: { loginViewModel in
            loginViewModel.login(userName: "firstUser",
                                 password: "firstPass",
                                 using: fakeRepository!)
        }) { loginViewModel in
            XCTAssertEqual((loginViewModel.loginState)?.isLoggedIn, true)
            XCTAssertEqual((loginViewModel.loginState)?.user, User(userName: "firstUser", email: "user1@users.com", phone: "12345678"))
            XCTAssert((loginViewModel.loginState)?.error == nil)
        }
        
        commonLoginTest(todoWithViewModel: { loginViewModel in
            loginViewModel.login(userName: "secondUser",
                                 password: "secondPass",
                                 using: fakeRepository!)
        }) { loginViewModel in
            XCTAssertEqual((loginViewModel.loginState)?.isLoggedIn, true)
            XCTAssertEqual((loginViewModel.loginState)?.user, User(userName: "secondUser", email: "user2@users.com", phone: "87654321"))
            XCTAssert((loginViewModel.loginState)?.error == nil)
        }
    }
    
    func testUnsuccessfulLogin() {
        commonLoginTest(todoWithViewModel: { loginViewModel in
            loginViewModel.login(userName: "firstUser2",
                                 password: "firstPass",
                                 using: fakeRepository!)
        }) { loginViewModel in
            XCTAssertEqual((loginViewModel.loginState)?.isLoggedIn, false)
            XCTAssertEqual(((loginViewModel.loginState)?.error as NSError?)?.domain, LoginRepositoryUtil.errorFactory(100).domain)
            XCTAssertEqual(((loginViewModel.loginState)?.error as NSError?)?.code, LoginRepositoryUtil.errorFactory(100).code)
        }
        
        commonLoginTest(todoWithViewModel: { loginViewModel in
            loginViewModel.login(userName: "firstUser",
                                 password: "firstPass2",
                                 using: fakeRepository!)
        }) { loginViewModel in
            XCTAssertEqual((loginViewModel.loginState)?.isLoggedIn, false)
            XCTAssertEqual(((loginViewModel.loginState)?.error as NSError?)?.domain, LoginRepositoryUtil.errorFactory(100).domain)
            XCTAssertEqual(((loginViewModel.loginState)?.error as NSError?)?.code, LoginRepositoryUtil.errorFactory(100).code)
        }
    }
    
    func testNoNetworkWhenLogin() {
        commonLoginTest(todoWithViewModel: { loginViewModel in
            loginViewModel.login(userName: "firstUser",
                                 password: "firstPass",
                                 using: mockRepositoryReturningError!)
        }) { loginViewModel in
            XCTAssertEqual((loginViewModel.loginState)?.isLoggedIn, false)
            XCTAssertEqual(((loginViewModel.loginState)?.error as NSError?)?.domain, NSURLErrorDomain)
            XCTAssertEqual(((loginViewModel.loginState)?.error as NSError?)?.code, NSURLErrorCannotConnectToHost)
        }
    }
}


