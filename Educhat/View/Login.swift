//
//  Login.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 02/11/23.
//

import SwiftUI

struct Login: View {
    @ObservedObject var result: UserController = UserController()
    @State private var email:String=""
    @State private var password=""
    @State private var wrongEmail=0
    @State private var wrongPassword=0
    @State var showregister = false
    @State var showmain = false
    @State var showAlertsuccess = false
    let didCompleteLoginProcess: (UserController) -> ()
    
    var body: some View {
        if showregister{
            Register()
        }
        else if showmain{
            MainMessages(p:result.p)
        }
        else{
            NavigationView{
                ZStack{
                    Color.blue
                        .ignoresSafeArea()
                    Circle()
                        .scale(1.7)
                        .foregroundColor(Color.white.opacity(0.15))
                    Circle()
                        .scale(1.35)
                        .foregroundColor(.white)
                    
                    VStack{
                        Text("Iniciar sesión")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        TextField("Email", text:$email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(Color.red, width: CGFloat(wrongEmail))
                            .autocapitalization(.none)
                        SecureField("Contraseña", text:$password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(Color.red, width: CGFloat(wrongPassword))
                            .autocapitalization(.none)
                        
                        Button(action:{
                            self.showAlertsuccess.toggle()
                            if(email.trim().isEmpty || password.trim().isEmpty){
                                result.dao.msjAlert = "Debe completar los campos"
                                if(email.trim().isEmpty){
                                    wrongEmail = 2
                                }
                                else{
                                    wrongEmail = 0
                                }
                                if(password.trim().isEmpty)
                                {
                                    wrongPassword = 2
                                }
                                else{
                                    wrongPassword = 0
                                }
                            }
                            else{
                                self.showAlertsuccess = false
                                let p = Persona()
                                p.email = email
                                p.passwo = password
                                result.index(p:p){res in
                                    if(!result.p.uid.isEmpty){
                                        self.showmain.toggle()
                                    }
                                    else{
                                        self.showAlertsuccess = true
                                    }
                                }
                            }
                            
                        }, label: {
                            Text("Iniciar sesión")
                                .foregroundColor(.white)
                                .bold()
                        })
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .alert(isPresented: $showAlertsuccess) {
                            Alert(title: Text("Inicio de sesión"), message: Text(result.dao.msjAlert), dismissButton: .default(Text("Aceptar")))
                            
                        }
                        
                        Button(action:{
                            self.showregister.toggle()
                            
                        }, label: {
                            Text("¿No tienes una cuenta aún?")
                                .bold()
                        })
                    }
                }
            }
            .navigationBarHidden(false)
            
        }
        
    }
}

extension String {
    func trim() -> String {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(didCompleteLoginProcess:{_ in
            
        })
    }
}
