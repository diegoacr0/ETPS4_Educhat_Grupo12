//
//  PersonaDAO.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 26/11/23.
//

import Combine
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftUI

class PersonaDAO: ObservableObject{
    @Published var r = false
    @Published var msjAlert = ""
    @Published var msjAlert1 = ""
    @Published var isUserCurrentlyLoggedIn = false
    
    func nuevoUsuario(p:Persona,completion: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: p.email, password: p.passwo){
            result, err in
            if let err = err{
                self.msjAlert="Ocurrio un error al crear el usuario \(err)"
                completion(self.msjAlert)
                return
            }
            else{
                self.msjAlert="Usuario creado correctamente \(result?.user.uid ?? "")"
                completion(self.msjAlert)
                self.ImagenStorage(p:p){res in
                    completion(self.msjAlert1)
                }
            }
        }
    }
    func informacionUsuario(p:Persona,imageProfileUrl: URL,completion: @escaping (String) -> Void){
        guard let uid = Auth.auth().currentUser?.uid
        else{
            return}
        let userData = ["nombre": p.nombre,"email": p.email, "uid": uid,"profileImageUrl": imageProfileUrl.absoluteString]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData){ err in
                if let err = err{
                    print(err)
                    completion("Error \(err)")
                    return
                }
                print("Guardado")
                self.r = true
                completion(self.msjAlert1)
            }
    }
    
    
    func loginUser(p:Persona,completion: @escaping (Persona) -> Void){
        Auth.auth().signIn(withEmail: p.email, password: p.passwo){
            result, err in
            if let err = err{
                self.msjAlert = "Ocurrio un error al iniciar sesión \(err)"
                completion(p)
                return
            }
            self.msjAlert = "Inicio de sesión correctamente \(result?.user.uid ?? "")"
            self.informacionUsuarioActual(){ res in
                completion(res)
            }
        }
    }
    
    func informacionUsuarioActual(completion : @escaping (Persona) -> Void){
        guard let uid = Auth.auth().currentUser?.uid //Verifica el codigo del usuario para poder continuar
        else{return}
        
        //Recolectar información del usuario de la sesión
        let p:Persona = Persona()
        Firestore.firestore().collection("users")
            .document(uid).getDocument{ snapshot, error in
                if let error = error{
                    print("Error en encontrar la informacion", error)
                    return
                }
                
                guard let data = snapshot?.data() else {return}
                p.email = data["email"] as? String ?? ""
                p.nombre = data["nombre"] as? String ?? ""
                p.urlimage = data["profileImageUrl"] as? String ?? ""
                p.uid = data["uid"] as? String ?? ""
                completion(p)
            }
    }
    
    func ImagenStorage(p:Persona,completion: @escaping (String) -> Void){
        //let filename = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid
        else{return}
        guard let imageData = p.image?.jpegData(compressionQuality: 0.5)
        else {return}
        let ref = Storage.storage().reference(withPath: uid)
        ref.putData(imageData,metadata: nil) {metadata, err in
            if let err = err {
                print("Error al guardar la imagen: \(err)")
                self.msjAlert1="Error al guardar la imagen de perfil: \(err)"
                completion(self.msjAlert1)
                return
            }
            ref.downloadURL{ url, err in
                if let err = err {
                    print("Error al encontrar la dirección de la imagen \(err)")
                    self.msjAlert1="Error al encontrar la dirección de la imagen de perfil \(err)"
                    completion(self.msjAlert1)
                    return
                }
                print("Imagen guardada con exito url : \(url?.absoluteString ?? "")")
                self.msjAlert1="Imagen de perfil guardada con exito url : \(url?.absoluteString ?? "")"
                completion(self.msjAlert1)
                guard let url = url else {return}
                self.informacionUsuario(p: p, imageProfileUrl: url){res in
                    completion(self.msjAlert1)
                }
            }
        }
    }
    
    func listarusuarios(completion: @escaping ([Persona]) -> Void){
        Firestore.firestore().collection("users")
            .getDocuments{ documentsSnapshot, error in
                if let error = error {
                    //self.msjAlert="Error al listar los usuarios: \(error)"
                    print("Error al listar los usuarios: \(error)")
                    return
                }
                var users: [Persona] = []
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let p = Persona()
                    p.email = data["email"] as? String ?? ""
                    p.nombre = data["nombre"] as? String ?? ""
                    p.urlimage = data["profileImageUrl"] as? String ?? ""
                    p.uid = data["uid"] as? String ?? ""
                    
                    if p.uid != Auth.auth().currentUser?.uid{
                        users.append(p)
                    }
                    completion(users)
                })
            }
    }
    
    func cerrasesion(){
        isUserCurrentlyLoggedIn.toggle()
        try? Auth.auth().signOut()
    }
}
