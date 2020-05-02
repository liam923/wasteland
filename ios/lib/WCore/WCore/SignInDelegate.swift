//
//  SignInDelegate.swift
//  WCore
//
//  Created by Liam Stevenson on 5/1/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import os

class SignInDelegate: NSObject, GIDSignInDelegate {
    static let shared = SignInDelegate()
    private override init() {
        super.init()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            os_log("Error signing in: %s", log: Log.firebase, type: .error, error.localizedDescription)
            return
        } else {
            guard let authentication = user.authentication else {
                os_log("Error signing in: Google user was missing authentication", log: Log.firebase, type: .error)
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (authData, error) in
                if let error = error {
                    os_log("Error signing in: %s", log: Log.firebase, type: .error, error.localizedDescription)
                    return
                } else {
                    AppModel.model.updateCurrentUser()
                }
            }
        }
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        AppModel.model.updateCurrentUser()
    }
}
