//
//  UserController.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 26/11/23.
//

import Combine

class UserController: ObservableObject{
    @Published var users: [Persona] = []
    @Published var recentMessages = [RecentMessage]()
    
    @Published var p:Persona = Persona()
    var dao = PersonaDAO()
    var daoChat = ChatDAO()
    
    init (){
        listarusuarios()
        listarmensajesrecientes()
    }
    
    func listarmensajesrecientes(){
        daoChat.listarmensajesrecientes(){res in
            self.recentMessages.removeAll()
            self.recentMessages = res
        }
    }
    
    func listarusuarios(){
        dao.listarusuarios(){res in
            self.users.removeAll()
            self.users = res
        }
        dao.informacionUsuarioActual(){ r in
            self.p = r
        }
    }
    
    
    func index(p:Persona, completion: @escaping (Persona) -> Void){
        dao.loginUser(p: p){res in
            self.p = res
            completion(res)
        }
    }
    
    func nuevoUsuario(p: Persona, completion: @escaping (String) -> Void){
        dao.nuevoUsuario(p: p){res in
            completion(self.dao.msjAlert)
        }
    }
    
    
}
