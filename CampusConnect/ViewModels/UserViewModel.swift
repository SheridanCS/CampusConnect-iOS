//
//  UserViewModel.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

/**
    NOT IN USE.
    ViewModel to handle the interactions between the view controller and the model.

    - Author: Timothy Catibog
*/
struct UserModel {
    let user : User
}

class UserViewModel : NSObject {
    private let userModel : UserModel

    init(user : UserModel) {
        self.userModel = user
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // ...
        }
    }
}
