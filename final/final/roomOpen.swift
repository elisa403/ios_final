//
//  roomOpen.swift
//  final
//
//  Created by Elisa Chien on 2023/5/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct roomOpen: View {
    @EnvironmentObject var settings : UserSettings
    @Binding var openRoom:Bool
    @State var num = ""
    @State var numAppear = false
    @State var rk = Rk(rank:[])
    @State var now = gameStruct(enter:false,quit:true,player: [], score: [], people: 0, card: 1,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    func createabc(){
        let db = Firestore.firestore()
        
        do{
            try
                db.collection(num).document("牌").setData(from: now)
//            db.collection("排行榜").document("心臟病").setData(from: rk)
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
                        openRoom.toggle()
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
                if numAppear{
                    Text(num)
                        .font(.title)
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .frame(width: 160,height: 60)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                else{
                    Button(settings.lang == 0 ? "Open Room" : "開啟房間"){
    //                    num = ["0000","0001","0002","0003","0004","0005","0006","0007"].randomElement()!
                        num = "0000"
                        createabc()
                        numAppear = true
                    }
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
                }
//                Button("首頁"){
//                    openRoom.toggle()
//                }
            }
        }
    }
}

struct roomOpen_Previews: PreviewProvider {
    static var previews: some View {
        roomOpen(openRoom: .constant(true))
    }
}
