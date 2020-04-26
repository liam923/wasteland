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
import FirebaseFirestore
import WCore

struct ContentView: View {
    @ObservedObject var model: AppModel
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(model.user?.currentDrinkingSession?.drinks ?? []) { (drink) -> Text in
                Text(drink.id)
            }
            Text(self.model.user?.currentDrinkingSession?.id ?? "nil")
            Button(action: {self.model.user?.currentDrinkingSession?.sendChanges(completion: {print($0)})}) {
                Text("Send")
            }
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
                    try Auth.auth().signOut()
                    AppModel.model.updateCurrentUser()
                } catch let signOutError as NSError {
                    os_log("Error signing out: %@", signOutError)
                }
            }) {
                Text("Sign Out")
            }
            Spacer()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(blackout: Blackout(id: "123", fromModel: Blackout.Model(startTime: Timestamp(), endTime: Timestamp(), reports: [], dissents: [], blackoutUserID: "id"), status: .untied))
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
