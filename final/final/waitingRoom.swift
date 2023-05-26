//
//  waitingRoom.swift
//  final
//
//  Created by Elisa Chien on 2023/5/16.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GameplayKit

struct waitingRoom: View {
    @EnvironmentObject var settings : UserSettings
    @Binding var enterRoom:Bool
    @Binding var room:String
    @State var now = gameStruct(enter:false,quit: true,player: [],score: [], people: 0, card: 0,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    @State var goTop = false
    @State var enterGame = false
    @State var cardPer = 0
    var array = ["s,1","s,2","s,3","s,4","s,5","s,6","s,7","s,8","s,9","s,10","s,11","s,12","s,13","h,1","h,2","h,3","h,4","h,5","h,6","h,7","h,8","h,9","h,10","h,11","h,12","h,13","d,1","d,2","d,3","d,4","d,5","d,6","d,7","d,8","d,9","d,10","d,11","d,12","d,13","c,1","c,2","c,3","c,4","c,5","c,6","c,7","c,8","c,9","c,10","c,11","c,12","c,13"]
//    var array = ["s,1","s,2","s,3","s,4","s,5"]
    @State var arrayRandom = []
    
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
        
        GeometryReader{geo in
            ZStack{
//                Color(red: 0.841, green: 0.936, blue: 0.965)
//                    .ignoresSafeArea()
                Image("b3")
                    .resizable()
                    .ignoresSafeArea()
                    
                HStack{
                    Spacer()
                    VStack{
                        Button {
                            now.card = 0
                            for i in 0..<now.player.count{
                                if now.player[i].id == settings.id{
                                    now.player.remove(at: i)
                                    break
                                }
                            }
                            createabc()
                            enterRoom.toggle()
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
                    VStack{
                        Text(settings.lang == 0 ? "Room Number:" + room : "房間號碼:"+room)
                            .bold()
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(Color.white)
                            .padding(EdgeInsets(top: geo.size.height/10, leading: 0, bottom: 0, trailing: 0))
                        Text(settings.lang == 0 ? "\(now.player.count) Player" : "人數:\(now.player.count)")
                            .bold()
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(Color.white)
                        HStack{
                            ForEach(now.player.indices,id: \.self){i in
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color(red: 0.312, green: 0.495, blue: 0.59),lineWidth: 5)
                                    .frame(height: geo.size.height/3)
                                    .font(.title)
                                    .background(Color.white)
                                    .cornerRadius(30)
                                    .overlay(
                                        VStack{
                                            Text(now.player[i].name)
                                                .bold()
                                                .fontWeight(.bold)
                                            Text(settings.lang == 0 ? "Score:\(now.player[i].score)" : "分數:\(now.player[i].score)")
                                                .bold()
                                                .fontWeight(.bold)
                                        }
                                            .font(.title)
                                            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                        
                                    
                                    )
                            }
                        }
                        .padding()
                        
                        HStack{
                            if now.player.count >= 2{
                                Button(action: {
                                    now.enter.toggle()
                                    arrayRandom = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: array)
                                    print(arrayRandom)
                                    cardPer = arrayRandom.count/now.player.count
                                    
                                    for i in (0..<now.player.count){
                                        now.player[i].card = []
                                        for j in (i*cardPer..<i*cardPer+cardPer){
                                            now.player[i].card += [arrayRandom[j] as! String]
                                        }
                                    }
                                    now.cardpool = []
                                    now.card = 0
                                    now.playing = true
                                    enterGame = now.enter
                                    now.losePlayer = []
                                    createabc()
                                    
                                }, label: {
                                    Text(settings.lang == 0 ? "Start Game" : "開始遊戲")
                                        .bold()
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                })
                                .fullScreenCover(isPresented: $enterGame, content: {game(enterGame: $enterGame, room: $room)})
                                .font(.title)
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .frame(width: 170,height: 50)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 2.5)
                                )
                            }
                            else{
                                Text(settings.lang == 0 ? "Waiting..." : "等待中...")
                                    .bold()
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .onAppear(perform: {
                            
                            let db = Firestore.firestore()
                            db.collection(room).document("牌").addSnapshotListener{snapshot,error in
                                guard let snapshot = snapshot else{return}
                                guard let abcc = try? snapshot.data(as:gameStruct.self)else{return}
                                now = abcc
                                enterGame = now.enter
                            }
                        })
                    }
                }
            }
            
    }
    }
}

struct waitingRoom_Previews: PreviewProvider {
    static var previews: some View {
        waitingRoom(enterRoom:.constant(true),room: .constant("0001"))
    }
}
