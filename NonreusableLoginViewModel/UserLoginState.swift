//
//  UserLoginState.swift
//  NonreusableLoginViewModel
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import UIKit

class UserLoginState: NSObject {
    
    let user: User?
    let error: Error?
    
    init(userName: String, email: String, phone: String) {
        self.user = User(userName: userName, email: email, phone: phone)
        self.error = nil
        super.init()
    }
    
    init(error: Error) {
        self.user = nil
        self.error = error
        super.init()
    }
    
    override init() {
        self.user = nil
        self.error = nil
        super.init()
    }
    
    var isLoggedIn: Bool {
        return user != nil
    }
}
