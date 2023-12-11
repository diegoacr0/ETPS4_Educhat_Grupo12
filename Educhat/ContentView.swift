//
//  ContentView.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 02/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Login(didCompleteLoginProcess:{_ in
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
