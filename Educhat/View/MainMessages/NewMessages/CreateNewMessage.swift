//
//  CreateNewMessage.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 2/12/23.
//

import SwiftUI
import URLImage

struct CreateNewMessage: View {
    
    let didSelectNewUser: (Persona) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var result: UserController = UserController()
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(result.users){ user in
                    
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label:{
                        HStack(spacing: 16){
                            if let url = URL(string: user.urlimage){
                                URLImage(url) { image in
                                    // Muestra la imagen cuando se carga correctamente
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                        .cornerRadius(50)
                                        .overlay(RoundedRectangle(cornerRadius: 50)
                                                    .stroke(Color(.label),lineWidth: 2)
                                        )
                                        .shadow(radius: 5)
                                }
                            }
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
            }.navigationTitle("Nuevo mensaje")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    }label: {
                        Text("Cancelar")
                    }
                }
            }
            //.navigationBarItems(leading: <#T##View#>)
        }
    }
}

struct CreateNewMessage_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessage(didSelectNewUser: { user in
        })
    }
}
