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

class SignInDelegate: NSObject, GIDSignInDelegate {
    static let shared = SignInDelegate()
    private override init() {
        super.init()
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            Log.error("Error signing in: \(error.localizedDescription)", category: .firebase)
            return
        } else {
            guard let authentication = user.authentication else {
                Log.error("Error signing in: Google user was missing authentication", category: .firebase)
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (_, error) in
                if let error = error {
                    Log.error("Error signing in: \(error.localizedDescription)", category: .firebase)
                    return
                } else {
                    App.core.updateCurrentUser()
                }
            }
        }
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        App.core.updateCurrentUser()
    }
}
