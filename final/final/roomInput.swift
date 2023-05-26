//
//  roomInput.swift
//  final
//
//  Created by Elisa Chien on 2023/5/5.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct roomInput: View {
    @EnvironmentObject var settings : UserSettings
    @Binding var inputRoom:Bool
    @Binding var loSettings:Data
    @State var room = "0000"
    @State var enterRoom = false
    @State var showAlert = false
    @State var playinfo = playerInfo(name: "", id: UUID(),score: 0,card: [],time: 10000.0)
    @State var now = gameStruct(enter:false,quit: false,player: [],score: [], people: 0, card: 0,cardpool: [""],nowTurn: 0,cardpoolNum: 0,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    @State var abcc = loUserSettings()
    
    func saveSet(){
        do {
        loSettings = try JSONEncoder().encode(abcc)
        } catch {
        print(error)
        }
    }
    func loadSet(){
        guard !loSettings.isEmpty else { return }
        do {
        abcc = try JSONDecoder().decode(loUserSettings.self, from: loSettings)
        } catch {
        print(error)
        }
    }
    
    func createabc(){
        let db = Firestore.firestore()
        
        do{
            try
                db.collection(room).document("牌").setData(from: now)
//            print("success")
        }catch{
            print(error)
        }
    }
    
    var body: some View {
        ZStack{
            Image("b2")
                .resizable()
                .scaledToFill()
                .clipped()
                .ignoresSafeArea()
            HStack{
                Spacer()
                VStack{
                    Button {
                        inputRoom.toggle()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.white)
                        }
                        .padding(20)
                    Spacer()
                }
            }
            VStack{
                TextField(settings.lang == 0 ? "Room Number" : "房間號碼", text: $room)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding()
                Button(settings.lang == 0 ? "Enter" : "進入"){
                    let db = Firestore.firestore()
                        let documentReference =
                        db.collection(room).document("牌")
                        documentReference.getDocument { document, error in
                            guard let document,
                                  document.exists,
                                  var abc = try? document.data(as: gameStruct.self)
                            else {
                                return
                            }
                            playinfo.id = settings.id
                            playinfo.name = settings.name
                            playinfo.score = settings.score
                            abc.player += [playinfo]
                            if(!abc.playing){
                                settings.index = abc.player.count-1
                                abcc.index = abc.player.count-1
                                saveSet()
                                do {
                                    try documentReference.setData(from: abc)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        enterRoom.toggle()
                    }
                    
                }
                .fullScreenCover(isPresented: $enterRoom, content: {waitingRoom(enterRoom: $enterRoom,room: $room)})
                .environmentObject(settings)
                .font(.title)
                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                .frame(width: 150,height: 50)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 2.5)
                )
//                Button("回首頁"){
//                    inputRoom.toggle()
//                }
            }
        }
        .onAppear{
            loadSet()
        }
    }
}

//struct roomInput_Previews: PreviewProvider {
//    static var previews: some View {
//        roomInput(inputRoom:.constant(true))
//    }
//}
