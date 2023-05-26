//
//  winlose.swift
//  final
//
//  Created by Elisa Chien on 2023/5/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct winlose: View {
    @EnvironmentObject var settings : UserSettings
    @Binding var room:String
    @Binding var goTop:Bool
    @Binding var enterGame:Bool
    @State var enterRoom = false
    @State var now = gameStruct(enter:false,quit:false,player: [],score: [], people: 0, card: 1,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: true,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    @State var new = gameStruct(enter:false,quit:true,player: [], score: [], people: 0, card: 1,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    func createabc(){
        let db = Firestore.firestore()
        do{
            try
                db.collection(room).document("牌").setData(from: now)
        }catch{
            print(error)
        }
    }
    var body: some View {
        VStack{
            if(now.player.count > settings.index){
                if(now.player[settings.index].card.count == 0){
                    Text("win")
                }
                else{
                    Text("lose")
                }
            }
            Button("離開"){
                new.player = now.player
                new.score = now.score
                now = new
                createabc()
            }
            .fullScreenCover(isPresented: $enterRoom, content: {waitingRoom(enterRoom: $enterRoom,room: $room)})
            .environmentObject(settings)
        }
        .onAppear(perform: {
            let db = Firestore.firestore()
            db.collection(room).document("牌").addSnapshotListener{snapshot,error in
                guard let snapshot = snapshot else{return}
                guard let abcc = try? snapshot.data(as:gameStruct.self)else{return}
                now = abcc
                goTop = now.quit
            }
        })
    }
}

struct winlose_Previews: PreviewProvider {
    static var previews: some View {
        winlose(room: .constant("0000"),goTop: .constant(false),enterGame: .constant(true))
    }
}
