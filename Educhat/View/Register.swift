//
//  Register.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 02/11/23.
//

import SwiftUI

struct Register: View {
    @ObservedObject var result: UserController = UserController()
    @State private var nombre=""
    @State private var apellido=""
    @State private var email=""
    @State private var password=""
    @State private var licencia=""
    @State private var wrongNombre=0
    @State private var wrongApellido=0
    @State private var wrongEmail=0
    @State private var wrongPassword=0
    @State private var wrongLicencia=0
    @State private var wrongImagen=0
    @State private var tipocuenta = false
    @State var showlogin = false
    @State private var showAlert = false
    @State var shouldShowImagePicker = false
    
    var body: some View {
        if showlogin{
            Login(didCompleteLoginProcess: {_ in
            })
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
                        .scale(1.60)
                        .foregroundColor(.white)
                    
                    VStack{
                        Text("Registrate")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        
                        Group{
                            Button{
                                shouldShowImagePicker.toggle()
                            } label:{
                                
                                VStack{
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 128, height: 128)
                                            .cornerRadius(64)
                                    }
                                    else{
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 64))
                                            .padding()
                                            .foregroundColor(Color(.label))
                                            .border(Color.red, width: CGFloat(wrongImagen))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 3)
                                )
                                
                            }
                           
                            TextField("Nombre", text:$nombre)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .border(Color.red, width: CGFloat(wrongNombre))
                            
                            TextField("Apellido", text:$apellido)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .border(Color.red, width: CGFloat(wrongApellido))
                            
                            
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
                            
                            
                            Button {
                                    tipocuenta.toggle()
                                    } label: {
                                        Text("Soy Maestro").foregroundColor(.black).bold()
                                        Image(systemName: tipocuenta ? "checkmark.circle.fill" : "circle")
                                    }
                            if tipocuenta{
                                TextField("Licencia", text:$licencia)
                                    .padding()
                                    .frame(width: 300, height: 50)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .border(Color.red, width: CGFloat(wrongLicencia))
                                    .autocapitalization(.none)
                                
                            }
                        
                        }
                        Button(action:{
                            self.result.dao.msjAlert1=""
                            self.showAlert = true
                            if(nombre.trim().isEmpty||apellido.trim().isEmpty||email.trim().isEmpty || password.trim().isEmpty || self.image == nil || self.tipocuenta==true){
                                if(nombre.trim().isEmpty){
                                    wrongNombre = 2
                                }
                                else{
                                    wrongNombre = 0
                                }
                                if(apellido.trim().isEmpty){
                                    wrongApellido = 2
                                }
                                else{
                                    wrongApellido = 0
                                }
                                
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
                                
                                if(self.image==nil){
                                    wrongImagen = 2
                                }
                                else{
                                    wrongImagen = 0
                                }
                                if(self.tipocuenta){
                                    if(licencia.trim().isEmpty){
                                        wrongLicencia = 2
                                    }
                                    else{
                                        wrongLicencia = 0
                                    }
                                }
                                self.result.dao.msjAlert = "Debe completar los campos"
                            }
                            else{
                                self.showAlert = false
                                let p = Persona()
                                p.nombre = "\(nombre) \(apellido)"
                                p.email = email
                                p.passwo = password
                                p.image = self.image
                                
                                result.nuevoUsuario(p: p){res in
                                    if(result.dao.r){
                                        self.showAlert = true
                                        self.nombre=""
                                        self.apellido=""
                                        self.email=""
                                        self.password=""
                                        self.licencia=""
                                        self.image=nil
                                    }
                                    else{
                                        self.showAlert = true
                                    }
                                }
                            }
                            
                        }, label: {
                            Text("Registrarse")
                                .foregroundColor(.white)
                                .bold()
                        })
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                       .alert(isPresented: $showAlert) {
                        Alert(title: Text("Registro de Usuario"), message: Text("\(self.result.dao.msjAlert) \n\n \(self.result.dao.msjAlert1)"), dismissButton: .default(Text("Aceptar")))
                        }
                        Button(action:{
                            self.showlogin.toggle()
                            
                        }, label: {
                            Text("Cancelar")
                                .bold()
                        })
                        
                    }
                }
            }
            .navigationBarHidden(false)
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                ImagePicker(image: $image)
            }
        }
    }
    @State var image: UIImage?
}


struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
