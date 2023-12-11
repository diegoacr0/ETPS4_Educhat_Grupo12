//
//  MainMessages.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 28/11/23.
//

import SwiftUI
import URLImage


struct MainMessages: View {
    @ObservedObject var resultchat: ChatController = ChatController(chatUser: nil)
    @ObservedObject var result: UserController = UserController()
    @ObservedObject var p:Persona
    @State var showAlerLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    
    private var header: some View{
        HStack(spacing: 16){
           //Imagen de perfil
            if let url = URL(string: p.urlimage){
                URLImage(url) { image in
                    // Muestra la imagen cuando se carga correctamente
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label),lineWidth: 1)
                        )
                        .shadow(radius: 5)
                }
            }
            else{
                Image(systemName: "person.fill")
                    .font(.system(size: 34, weight: .heavy))
            }
          
            VStack(alignment: .leading, spacing: 4){
                Text(p.nombre)
                    .font(.system(size: 24,weight: .bold))
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width:14, height: 14)
                    Text("En linea")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button{
                showAlerLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $showAlerLogOutOptions){
            .init(title: Text("Configuracion"), message: Text("¿Deseas salir?"), buttons: [
                .destructive(Text("Cerrar sesión"), action: {
                    print("Cerrando sesión")
                    result.dao.cerrasesion()
                }),
                //.default(Text("Default Button")),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented: $result.dao.isUserCurrentlyLoggedIn, onDismiss: nil){
            Login(didCompleteLoginProcess:{_ in 
                self.result.dao.isUserCurrentlyLoggedIn = false
                self.result.listarusuarios()
                self.result.listarmensajesrecientes()
            })
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                header
                bodyMessageView
                NavigationLink(
                    "",
                    destination: ChatLog(chatUser: self.chatUser, resultuser: result),
                    isActive: $shouldNavigateToChatLogView
                )
                
            }
            .overlay(
                newMessageButton, alignment: .bottom
            )
            .navigationBarHidden(true)
        }
    }
    
    private var bodyMessageView: some View{
        ScrollView{
            ForEach(result.recentMessages){recentMessage in
                Button{
                    let datos = Persona()
                    if(result.p.uid == recentMessage.toId){
                        
                        datos.uid = recentMessage.fromId
                    }
                    else{
                        datos.uid = recentMessage.toId
                    }
                    datos.email = recentMessage.email
                    datos.urlimage = recentMessage.profileImageUrl
                    self.chatUser = datos
                    print(datos.uid)
                    print (datos.email)
                    //result.listarmensajesrecientes()
                    shouldNavigateToChatLogView.toggle()
                    //ChatLog(chatUser: recentMessage, resultuser: result)
                }label:{
                    VStack{
                        HStack(spacing: 16){
                            if let url = URL(string: recentMessage.profileImageUrl){
                                URLImage(url) { image in
                                    // Muestra la imagen cuando se carga correctamente
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .clipped()
                                        .cornerRadius(64)
                                        .overlay(RoundedRectangle(cornerRadius: 64)
                                                    .stroke(Color(.label),lineWidth: 1)
                                        )
                                        .shadow(radius: 5)
                                }
                            }
                            VStack(alignment: .leading){
                                Text(recentMessage.username)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            }
                            Spacer()
                            Text(recentMessage.timestamp.description)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                        Divider()
                            .padding(.vertical, 8)
                    }.padding(.horizontal)
                    
                }
            }
        }.padding(.bottom, 50)
    }
    
    @State var shouldShowNewMessageScreen = false
    
    private var newMessageButton: some View{
        Button {
            shouldShowNewMessageScreen.toggle()
        } label:{
            HStack{
                Spacer()
                Text("+ Nuevo Mensaje")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen){
            CreateNewMessage(didSelectNewUser: { user
                in
                print(user.email)
                print(user.uid)
                self.chatUser = user
                self.shouldNavigateToChatLogView.toggle()
                self.resultchat.listarmensajes()
            })
        }
    }
    
    @State var chatUser: Persona?
}

struct MainMessages_Previews: PreviewProvider {
    static var previews: some View {
        MainMessages(p:Persona())
            //.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
