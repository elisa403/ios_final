//
//  ContentView.swift
//  final
//
//  Created by User05 on 2023/4/19.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct ContentView: View {
    @AppStorage("loSettings") var loSettings = Data()
    @StateObject var settings = UserSettings()
    @State private var viewModel = contenViewModel()
    
    var body: some View {
        ZStack{
            Image("b5")
                .resizable()
                .scaledToFill()
                .clipped()
                .ignoresSafeArea()
                
            GeometryReader{geo in
                VStack{
                    HStack{
                        Text(settings.lang == 0 ? "Welcome! " + settings.name : settings.name + " 你好")
                            .font(.title3)
                            .bold()
                        Button(settings.name == "訪客" ? (settings.lang == 0 ? "Register" : "註冊") : ""){
                            viewModel.goRegister.toggle()
                        }
                        .fullScreenCover(isPresented: $viewModel.goRegister, content: {register(goRegister:$viewModel.goRegister,log:$viewModel.log)})
                        .environmentObject(settings)
                        .font(.title3)
                        
                        Button(settings.name == "訪客" ? (settings.lang == 0 ? "Login" : "登入") : ""){
                            viewModel.goLogin.toggle()
                        }
                        .fullScreenCover(isPresented: $viewModel.goLogin, content: {login(goLogin:$viewModel.goLogin,log:$viewModel.log)})
                        .environmentObject(settings)
                        .font(.title3)
                       
                        Button(settings.name == "訪客" ?  "" : (settings.lang == 0 ? "Logout" : "登出")){
                            settings.name = "訪客"
                            settings.email = ""
                            settings.password = ""
                            settings.score = 0
                            settings.id = UUID()
                            viewModel.abcc.name = settings.name
                            viewModel.abcc.score = settings.score
                            viewModel.abcc.id = settings.id
                            viewModel.abcc.email = settings.email
                            viewModel.abcc.password = settings.password
                            
                            do {
                                loSettings = try JSONEncoder().encode(viewModel.abcc)
                            } catch {
                            print(error)
                            }
                            
                            viewModel.log = false
                        }
                        .font(.title3)
                    }
                    .padding(30)
                    HStack{
                        Spacer()
                        if(settings.lang == 0){
                            VStack{
                                Image("title0.0")
                                    .resizable()
                                    .frame(width: geo.size.width/1.5,height: geo.size.width/4.6)
                                Image("title0.1")
                                    .resizable()
                                    .frame(width: geo.size.width/1.4,height: geo.size.width/4.6)
                            }
//                            .padding(EdgeInsets(top: 0, leading: -30, bottom: 0, trailing: 0))
                        }
                        else{
                            Image("title1")
                                .resizable()
                                .frame(width: geo.size.width/1.4,height: geo.size.width/4.2)
                        }
                        Spacer()
                    }
                    .frame(height: geo.size.height/2.5)
                    .padding(EdgeInsets(top: geo.size.height/18, leading: 0, bottom: geo.size.height/18, trailing: 0))
                    
                    HStack{
                        Button(settings.lang == 0 ? "Ranking" : "查看排行"){
                            viewModel.goRank.toggle()
                        }
                        .sheet(isPresented: $viewModel.goRank, content: {Ranking(goRank:$viewModel.goRank)})
                        .environmentObject(settings)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .frame(width: 100,height: 16)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                        
                        Button(settings.lang == 0 ? "Settings" : "遊戲設定"){
                            viewModel.goSet.toggle()
                        }
                        .sheet(isPresented: $viewModel.goSet, content: {setting(goSet:$viewModel.goSet)})
                        .environmentObject(settings)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .frame(width: 100,height: 16)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                    }
    //                Button(settings.lang == 0 ? "Start Game" : "進入隨機房間"){
    //                    let db = Firestore.firestore()
    //                        let documentReference =
    //                        db.collection("0008").document("牌")
    //                        documentReference.getDocument { document, error in
    //                            guard let document,
    //                                  document.exists,
    //                                  var abc = try? document.data(as: gameStruct.self)
    //                            else {
    //                                return
    //                            }
    //                            playinfo.id = settings.id
    //                            playinfo.name = settings.name
    //                            playinfo.score = settings.score
    //                            abc.player += [playinfo]
    //                            if(!abc.playing){
    //                                settings.index = abc.player.count-1
    //                                do {
    //                                    try documentReference.setData(from: abc)
    //                                } catch {
    //                                    print(error)
    //                                }
    //                            }
    //                        }
    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
    //                        enterRoom.toggle()
    //                    }
    //                }
    //                .fullScreenCover(isPresented: $enterRoom, content: {waitingRoom(enterRoom: $enterRoom,room: $room)})
    //                .environmentObject(settings)
                    
                    Button(settings.lang == 0 ? "Input Room Number" : "輸入遊戲房間"){
                        if(viewModel.abcc.name == ""){
                            viewModel.abcc.name = settings.name
                            viewModel.abcc.score = settings.score
                            viewModel.abcc.index = settings.index
                            viewModel.abcc.id = settings.id
                            viewModel.abcc.email = settings.email
                            viewModel.abcc.password = settings.password
                        }
                        
                        do {
                            loSettings = try JSONEncoder().encode(viewModel.abcc)
                        } catch {
                        print(error)
                        }
                        
                        viewModel.inputRoom.toggle()
                    }
                    .sheet(isPresented: $viewModel.inputRoom, content: {roomInput(inputRoom:$viewModel.inputRoom,loSettings: $loSettings)})
                    .environmentObject(settings)
                    .font(.title3)
                    .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                    .frame(width: 190,height: 16)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2.5)
                    )
                    Button(settings.lang == 0 ? "Open New Room" : "開啟新房間"){
                        viewModel.openRoom.toggle()
                    }
                    .sheet(isPresented: $viewModel.openRoom, content: {roomOpen(openRoom:$viewModel.openRoom)})
                    .environmentObject(settings)
                    .font(.title3)
                    .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                    .frame(width: 190,height: 16)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2.5)
                    )
                    
                    
                    
                    
                        
                }
            }
            .foregroundColor(Color.white)
        }
        .onAppear{
            guard !loSettings.isEmpty else { return }
            do {
                viewModel.abcc = try JSONDecoder().decode(loUserSettings.self, from: loSettings)
            } catch {
            print(error)
            }
            settings.name = viewModel.abcc.name
            settings.score = viewModel.abcc.score
            settings.index = viewModel.abcc.index
            settings.id = viewModel.abcc.id
            settings.email = viewModel.abcc.email
            settings.password = viewModel.abcc.password
            settings.bgm = viewModel.abcc.bgm
            settings.lang = viewModel.abcc.lang
            if(viewModel.abcc.bgm != 0){
                if(viewModel.abcc.bgm == 1){
                    AVPlayer.setupBgMusic1()
                    AVPlayer.bgQueuePlayer.play()
                }
                else if(viewModel.abcc.bgm == 2){
                    AVPlayer.setupBgMusic2()
                    AVPlayer.bgQueuePlayer.play()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
