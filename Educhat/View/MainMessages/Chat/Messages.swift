//
//  Messages.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 4/12/23.
//

import SwiftUI

struct Messages: View {
    let message: Chat
    let currentuser: String?
    var body: some View {
        VStack{
            if message.fromId == currentuser{
                HStack{
                    Spacer()
                    HStack{
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            else{
                HStack{
                    HStack{
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top,8)
    }
}
