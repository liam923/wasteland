//
//  ContentView.swift
//  Wasteland
//
//  Created by Liam Stevenson on 1/30/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import os
import MapKit
import WCore

struct ContentView: View {
    @ObservedObject var model: App

    var body: some View {
        VStack {
            Spacer()
            ForEach(model.user?.currentDrinkingSession?.drinks ?? []) { (drink) -> Text in
                Text(drink.id)
            }
            Text(self.model.user?.currentDrinkingSession?.id ?? "nil")
            SignInView()
            Spacer()
        }
    }
}

struct SignInView: View {
    var body: some View {
        VStack {
            SignInPresenter()
            Button(action: {
                do {
                    try App.core.signOut()
                } catch let signOutError as NSError {
                    os_log("Error signing out: %@", signOutError)
                }
            }, label: {
                Text("Sign Out")
            })
            Spacer()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(model: AppModel.model)
//    }
//}

struct SignInPresenter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view = GIDSignInButton()
        GIDSignIn.sharedInstance()?.presentingViewController = controller
        return controller
    }

    func updateUIViewController(_ view: UIViewController, context: Context) {

    }
}
