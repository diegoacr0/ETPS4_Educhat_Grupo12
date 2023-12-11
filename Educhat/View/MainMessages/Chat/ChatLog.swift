//
//  ChatLog.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 2/12/23.
//

import SwiftUI

struct ChatLog: View {
    @ObservedObject var result: ChatController
    @ObservedObject var resultuser: UserController
    @State var shouldShowImagePicker = false
    @State var shouldShowImage = false
    var chatUser1: Persona?
    
    //var useractual:Persona
    
    /*init(chatUser: Persona?,resultuser: UserController){
        self.chatUser = chatUser
        //self.useractual = useractual
        self.resultuser = resultuser
        self.result = .init(chatUser: chatUser)
    }*/
    init (chatUser: Persona?, resultuser: UserController){
        self.resultuser = resultuser
        self.chatUser1 = chatUser
        self.result = .init(chatUser: chatUser)
        //result.listarmensajes()
    }

    var body: some View {
        if(self.image != nil){
            PreviewImage(chatUser: self.chatUser1,result: ChatController(chatUser: self.chatUser1),resultuser: UserController(),image: self.image)
        }
        else{
            ZStack{
                messagesView
            }
            .navigationTitle(result.chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear{
                result.chatMessages.removeAll()
                resultuser.recentMessages.removeAll()
                resultuser.listarmensajesrecientes()
            }
        }
    }
    static let emptyScrollToString = "Empty"
    private var messagesView: some View{
            VStack{
                ScrollView{
                    ScrollViewReader {scrollViewProxy in
                            VStack{
                                ForEach(self.result.chatMessages){ message in
                                            Messages(message: message, currentuser: result.dao.currentUser)
                                    }
                                    HStack{
                                        Spacer()
                                    }
                                    .id(Self.emptyScrollToString)
                            }
                            .onReceive(result.dao.$count) { _ in
                                withAnimation(.easeOut(duration: 0.5)){
                                    scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                                }
                            }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .overlay(
                chatBottomBar
                    .background(Color(.systemBackground)
                                    .ignoresSafeArea())
                ,
                alignment: .bottom
                )
    }
    @State var image: UIImage?
    private var chatBottomBar: some View{
        HStack(spacing: 16){
            
            
            /*
            NavigationLink(
                "",
                destination: PreviewImage(image: self.image),
                isActive: $shouldShowImage
            )
            EmptyView().fullScreenCover(isPresented: $shouldShowImage){
                PreviewImage(image: self.image)
            }*/
            
            Button{
                
                shouldShowImagePicker.toggle()
                
            }label:{
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                
            }
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
                if(!result.chatText.trim().isEmpty){
                    result.enviarmsj(useractual: resultuser.p){res in
                        print(res)
                        if (res == "1"){
                            print(self.result.dao.count)
                            self.result.chatText = ""
                            self.result.listarmensajes()
                            self.resultuser.listarusuarios()
                        }
                    }
                }
            } label:{
                Text("Enviar")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical,8)
            .background(Color.blue)
            .cornerRadius(4)
            
        }
        .padding(.horizontal)
        .padding(.vertical,8)
        
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
    }
}

struct ChatLog_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChatLog(chatUser: Persona(), resultuser: UserController())
        }
    }
}
