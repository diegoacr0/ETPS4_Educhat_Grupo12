//
//  PreviewImage.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 8/12/23.
//

import SwiftUI

struct PreviewImage: View {
    @ObservedObject var result: ChatController
    @ObservedObject var resultuser: UserController
    @State var image: UIImage?
    var chatUser1: Persona?
    
    init(chatUser: Persona?, result: ChatController, resultuser: UserController, image: UIImage?){
        self.resultuser = resultuser
        _image = State(initialValue: image)
        self.chatUser1 = chatUser
        self.result = .init(chatUser: chatUser)
        
    }
    
    var body: some View {
        if let image = self.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
            
            ZStack{
                Text("Escribe aquí tu mensaje.")
                TextEditor(text: $result.chatText)
                    .padding(4)
                    .frame(width: 230, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary).opacity(0.5))
                    .opacity(result.chatText.isEmpty ? 0.5 : 1)
            }
            Button{
                resultuser.p.image1 = self.image
                result.enviarimagenchat(useractual: resultuser.p){res in
                    print(res)
                    if (res == "1"){
                        print("SI LOGRO ENVIAR LA IMAGEN")
                    }
                    else{
                        print("F")
                    }
                }
                //result.prueba()
   
            } label:{
                Text("Enviar")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical,8)
            .background(Color.blue)
            .cornerRadius(4)
        }
    }
}

struct PreviewImage_Previews: PreviewProvider {
    static var previews: some View {
        PreviewImage(chatUser: Persona(),result: ChatController(chatUser: nil), resultuser: UserController(), image: UIImage())
    }
}
