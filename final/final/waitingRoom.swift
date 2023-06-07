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
    @State private var viewModel = waitingRoomViewModel()
    
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
                            viewModel.now.card = 0
                            for i in 0..<viewModel.now.player.count{
                                if viewModel.now.player[i].id == settings.id{
                                    viewModel.now.player.remove(at: i)
                                    break
                                }
                            }
                            let db = Firestore.firestore()
                            do{
                                try
                                db.collection(room).document("牌").setData(from: viewModel.now)
                            }catch{
                                print(error)
                            }
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
                        Text(settings.lang == 0 ? "\(viewModel.now.player.count) Player" : "人數:\(viewModel.now.player.count)")
                            .bold()
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(Color.white)
                        HStack{
                            ForEach(viewModel.now.player.indices,id: \.self){i in
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color(red: 0.312, green: 0.495, blue: 0.59),lineWidth: 5)
                                    .frame(height: geo.size.height/3)
                                    .font(.title)
                                    .background(Color.white)
                                    .cornerRadius(30)
                                    .overlay(
                                        VStack{
                                            Text(viewModel.now.player[i].name)
                                                .bold()
                                                .fontWeight(.bold)
                                            Text(settings.lang == 0 ? "Score:\(viewModel.now.player[i].score)" : "分數:\(viewModel.now.player[i].score)")
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
                            if viewModel.now.player.count >= 2{
                                Button(action: {
                                    viewModel.now.enter.toggle()
                                    let arrayRandom = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: viewModel.array)
                                    viewModel.cardPer = arrayRandom.count/viewModel.now.player.count
                                    
                                    for i in (0..<viewModel.now.player.count){
                                        viewModel.now.player[i].card = []
                                        for j in (i*viewModel.cardPer..<i*viewModel.cardPer+viewModel.cardPer){
                                            viewModel.now.player[i].card += [arrayRandom[j] as! String]
                                        }
                                    }
                                    viewModel.now.cardpool = []
                                    viewModel.now.card = 0
                                    viewModel.now.playing = true
                                    viewModel.enterGame = viewModel.now.enter
                                    viewModel.now.losePlayer = []
                                    
                                    let db = Firestore.firestore()
                                    do{
                                        try
                                        db.collection(room).document("牌").setData(from: viewModel.now)
                                    }catch{
                                        print(error)
                                    }
                                    
                                }, label: {
                                    Text(settings.lang == 0 ? "Start Game" : "開始遊戲")
                                        .bold()
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                })
                                .fullScreenCover(isPresented: $viewModel.enterGame, content: {game(enterGame: $viewModel.enterGame, room: $room)})
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
                                viewModel.now = abcc
                                viewModel.enterGame = viewModel.now.enter
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
