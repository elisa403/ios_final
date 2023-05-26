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

extension AVPlayer {
    static let sharedFlipPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "flip", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static let sharedWinPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "win", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static let sharedLosePlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "lose", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    static let sharedpaiPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "pai", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    static let sharedbubuPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "bubu", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()

    func playFromStart() {
        seek(to: .zero)
        play()
    }
    
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    static func setupBgMusic3() {
        guard let url = Bundle.main.url(forResource: "bgm3",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    static func setupBgMusic1() {
        guard let url = Bundle.main.url(forResource: "bgm1",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    static func setupBgMusic2() {
        guard let url = Bundle.main.url(forResource: "bgm2",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}

struct ContentView: View {
    @AppStorage("loSettings") var loSettings = Data()
    @StateObject var settings = UserSettings()
    @State var log = false
    @State var inputRoom = false
    @State var goRegister = false
    @State var goLogin = false
    @State var openRoom = false
    @State var abcc = loUserSettings()
    @State var goRank = false
    @State var goSet = false
    @State var enterRoom = false
    @State var playinfo = playerInfo(name: "", id: UUID(),score: 0,card: [],time: 10000.0)
    @State var room = "0008"
    func loadSet(){
        guard !loSettings.isEmpty else { return }
        do {
        abcc = try JSONDecoder().decode(loUserSettings.self, from: loSettings)
        } catch {
        print(error)
        }
    }
    func saveSet(){
        do {
        loSettings = try JSONEncoder().encode(abcc)
        } catch {
        print(error)
        }
    }
    
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
                            goRegister.toggle()
                        }
                        .fullScreenCover(isPresented: $goRegister, content: {register(goRegister:$goRegister,log:$log)})
                        .environmentObject(settings)
                        .font(.title3)
                        
                        Button(settings.name == "訪客" ? (settings.lang == 0 ? "Login" : "登入") : ""){
                            goLogin.toggle()
                        }
                        .fullScreenCover(isPresented: $goLogin, content: {login(goLogin:$goLogin,log:$log)})
                        .environmentObject(settings)
                        .font(.title3)
                       
                        Button(settings.name == "訪客" ?  "" : (settings.lang == 0 ? "Logout" : "登出")){
                            settings.name = "訪客"
                            settings.email = ""
                            settings.password = ""
                            settings.score = 0
                            settings.id = UUID()
                            abcc.name = settings.name
                            abcc.score = settings.score
                            abcc.id = settings.id
                            abcc.email = settings.email
                            abcc.password = settings.password
                            saveSet()
                            log = false
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
                            goRank.toggle()
                        }
                        .sheet(isPresented: $goRank, content: {Ranking(goRank:$goRank)})
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
                            goSet.toggle()
                        }
                        .sheet(isPresented: $goSet, content: {setting(goSet:$goSet)})
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
                        if(abcc.name == ""){
                            abcc.name = settings.name
                            abcc.score = settings.score
                            abcc.index = settings.index
                            abcc.id = settings.id
                            abcc.email = settings.email
                            abcc.password = settings.password
                        }
                        saveSet()
                        inputRoom.toggle()
                    }
                    .sheet(isPresented: $inputRoom, content: {roomInput(inputRoom:$inputRoom,loSettings: $loSettings)})
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
                        openRoom.toggle()
                    }
                    .sheet(isPresented: $openRoom, content: {roomOpen(openRoom:$openRoom)})
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
            loadSet()
            settings.name = abcc.name
            settings.score = abcc.score
            settings.index = abcc.index
            settings.id = abcc.id
            settings.email = abcc.email
            settings.password = abcc.password
            settings.bgm = abcc.bgm
            settings.lang = abcc.lang
            if(abcc.bgm != 0){
                if(abcc.bgm == 1){
                    AVPlayer.setupBgMusic1()
                    AVPlayer.bgQueuePlayer.play()
                }
                else if(abcc.bgm == 2){
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
