//
//  ChatDAO.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 3/12/23.
//

import Combine
import FirebaseAuth
import Firebase
import FirebaseStorage

class ChatDAO : ObservableObject{
    @Published var msj=""
    @Published var currentUser = Auth.auth().currentUser?.uid
    @Published var count = 0
    
    
    func enviarmsj(chat: Persona?,chatText: String,useractual: Persona, completion: @escaping (String) -> Void){
        guard let fromId =
                Auth.auth().currentUser?.uid else{return}
        
        guard let toId = chat?.uid else{return}
        
        let document = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        var messageData = [String: Any]()
        if(chat?.urlimage1 == ""){
            messageData =  ["fromId": fromId, "toId": toId, "text": chatText, "timestamp": Date()] as [String : Any]
        }
        else{
            messageData =  ["fromId": fromId, "toId": toId, "descripcion": chatText,"imagen": chat?.urlimage1 ?? "", "timestamp": Date()] as [String : Any]
        }
        
        //Envia el mensaje
        document.setData(messageData) {error in
            if let error = error {
                self.msj = "Error al guardar el mensaje \(error)"
                return
            }
            print("Mensaje enviado correctamente del usuario actual")
            self.count += 1
            self.persisRecentMessage(chat: chat, chatText: chatText, useractual: useractual)
            
            completion("1")
        }
        
        let recipientMessageDocument = Firestore.firestore()
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        //Guarda los siguientes mensajes a enviar en una ubicacion especifica
        recipientMessageDocument.setData(messageData) {error in
            if let error = error {
                self.msj = "Error al guardar el mensaje \(error)"
                return
            }
            print("Mensaje guardado")
            self.count += 1
        }
    }
    
    func listarmensajes(chat: Persona?,completion: @escaping ([Chat])-> Void){
        var chatMessages: [Chat] = []
        guard let fromId =
                Auth.auth().currentUser?.uid else{return}
        guard let toId = chat?.uid else{return}
        Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener{ querySnapshot, error in
                if let error = error {
                    self.msj = "Error en listar los mensajes \(error)"
                    print(error)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let chatMessage = Chat()
                        chatMessage.documentId = change.document.documentID
                        chatMessage.fromId = data["fromId"] as? String ?? ""
                        chatMessage.text = data["text"] as? String ?? ""
                        chatMessage.toId = data["toId"] as? String ?? ""
                        chatMessages.append(chatMessage)
                        completion(chatMessages)
                    }
                })
                DispatchQueue.main.async {
                    self.count = 1
                }
                
            }
    }
    
    func persisRecentMessage(chat: Persona?, chatText: String, useractual: Persona){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let toId = chat?.uid else {return}
        let document = Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        var data = [String: Any]()
        if (chat?.urlimage1 == ""){
            data = [
                "timestamp": Timestamp(),
                "text": chatText,
                "fromId" : uid,
                "toId" : toId,
                "profileImageUrl": chat?.urlimage ?? "",
                "email": chat?.email ?? ""
            ]
        }
        else{
            data = [
                "timestamp": Timestamp(),
                "descripcion": chatText,
                "imagen": chat?.urlimage1 ?? "",
                "fromId" : uid,
                "toId" : toId,
                "profileImageUrl": chat?.urlimage ?? "",
                "email": chat?.email ?? ""
            ]
        }
        
        document.setData(data){ error in
            if let error = error{
                self.msj = "Error en guardar el mensaje reciente \(error)"
                print("Error en guardar el mensaje reciente \(error)")
                return
            }
        }
        
        var datarecipient = [String: Any]()
        if(chat?.urlimage1 == ""){
            datarecipient = [
                "timestamp": Timestamp(),
                "text": chatText,
                "fromId" : uid,
                "toId" : toId,
                "profileImageUrl": useractual.urlimage,
                "email": useractual.email
            ]
        }
        else{
            datarecipient = [
                "timestamp": Timestamp(),
                "descripcion": chatText,
                "imagen": chat?.urlimage1 ?? "",
                "fromId" : uid,
                "toId" : toId,
                "profileImageUrl": useractual.urlimage,
                "email": useractual.email
            ]
        }
        
        
        let recipientMessageDocument = Firestore.firestore()
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(uid)
        
        //Guarda los siguientes mensajes a enviar en una ubicacion especifica
        recipientMessageDocument.setData(datarecipient) {error in
            if let error = error {
                self.msj = "Error al guardar el mensaje \(error)"
                return
            }
            print("Mensaje guardado")
        }

    }
    
    func listarmensajesrecientes(completion: @escaping ([RecentMessage]) -> Void){
        var recentMessages: [RecentMessage] = []
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener{ querySnapshot, error in
                if let error = error {
                    self.msj = "Error al listar los mensajes recientes \(error)"
                    print(error)
                    return
                }
               
                querySnapshot?.documentChanges.forEach({ change in
                    //if change.type == .added{
                        let docID = change.document.documentID
                        let data = change.document.data()
                        let recenteMessage = RecentMessage()
                        
                        recenteMessage.documentId = docID
                        recenteMessage.fromId = data["fromId"] as? String ?? ""
                        recenteMessage.text = data["text"] as? String ?? ""
                        recenteMessage.email = data["email"] as? String ?? ""
                        recenteMessage.profileImageUrl = data["profileImageUrl"] as? String ?? ""
                        recenteMessage.toId = data["toId"] as? String ?? ""
                        recenteMessage.timestamp = recenteMessage.timeAgo(fecha: data["timestamp"] as? Date ?? Date())
                        recentMessages.append(recenteMessage)
                        completion(recentMessages)
                    //}
                })
            }
    }
    
    
    func ImagenStorage(chat: Persona?,/*chatText: String,useractual: Persona,*/ completion: @escaping (String) -> Void){
        //let filename = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid
        else{return}
        guard let imageData = chat?.image1?.jpegData(compressionQuality: 0.5)
        else {return}
        let ref = Storage.storage().reference(withPath: uid)
        ref.putData(imageData,metadata: nil) {metadata, err in
            if let err = err {
                print("Error al guardar la imagen: \(err)")
                self.msj="Error al guardar la imagen de perfil: \(err)"
                completion(self.msj)
                return
            }
            ref.downloadURL{ url, err in
                if let err = err {
                    print("Error al encontrar la dirección de la imagen \(err)")
                    self.msj="Error al encontrar la dirección de la imagen de perfil \(err)"
                    completion(self.msj)
                    return
                }
                print("Imagen guardada con exito url : \(url?.absoluteString ?? "")")
                self.msj="Imagen de perfil guardada con exito url : \(url?.absoluteString ?? "")"
                completion(self.msj)
                guard let url = url else {return}
                chat?.urlimage1 = url.absoluteString
                completion(chat?.urlimage1 ?? "")
            }
        }
    }
}
