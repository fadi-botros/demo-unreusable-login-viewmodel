//
//  LoginViewModel.swift
//  NonreusableLoginViewModel
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import UIKit

protocol LoginRepository {
    func login(userName: String, password: String, completion: @escaping (User?, Error?) -> ())
}

struct LoginRepositoryUtil {
    static func errorFactory(_ code: Int, userInfo: [String: Any]? = nil) -> NSError {
        let domain = (Bundle.main.bundleIdentifier ?? "") + ".LoginError"
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}

class LoginViewModel: NSObject {
    @objc dynamic var loginState: UserLoginState?
    
    func login(userName: String, password: String, using: LoginRepository) {
        using.login(userName: userName, password: password, completion: {user, error in
            if let err = error {
                self.loginState = UserLoginState(error: err)
            } else if let user = user {
                self.loginState = UserLoginState(userName: user.userName,
                                                 email: user.email,
                                                 phone: user.phone)
            } else {
                self.loginState = UserLoginState()
            }
        })
    }
}
