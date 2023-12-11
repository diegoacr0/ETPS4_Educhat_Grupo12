//
//  EduchatApp.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 26/11/23.
//

import SwiftUI
import FirebaseCore


@main
struct EduchatApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //MainMessages()
        }
    }
}
