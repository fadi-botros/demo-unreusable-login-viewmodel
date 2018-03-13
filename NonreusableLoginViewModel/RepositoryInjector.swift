//
//  RepositoryInjector.swift
//  NonreusableLoginViewModel
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import UIKit

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

struct RepositoryInjector {
    static var repository: LoginRepository { return FakeLoginRepository() }
}
