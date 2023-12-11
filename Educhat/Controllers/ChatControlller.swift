//
//  ChatControlller.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 3/12/23.
//

import Combine

class ChatController: ObservableObject{
    @Published var chatMessages: [Chat] = []
    @Published var chatText = ""
    
    @Published var chatUser: Persona?
    var dao = ChatDAO()
 
    init(chatUser: Persona?){
        self.chatUser = chatUser
        listarmensajes()
    }
    func enviarimagenchat(useractual: Persona, completion: @escaping (String) -> Void){
        dao.ImagenStorage(chat: self.chatUser/*, chatText: self.chatText, useractual: useractual*/){res in
            completion(res)
        }
    }
    func enviarmsj(useractual: Persona, completion: @escaping (String) -> Void){
        dao.enviarmsj(chat: self.chatUser, chatText: self.chatText, useractual: useractual){res in
           completion(res)
        }
    }
    
    func listarmensajes(){
        dao.listarmensajes(chat:self.chatUser){res in
            self.chatMessages.removeAll()
            self.chatMessages = res
        }
    }
    
    func prueba(){
        print("conexion")
    }
}
