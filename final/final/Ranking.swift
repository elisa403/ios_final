//
//  Ranking.swift
//  final
//
//  Created by Elisa Chien on 2023/5/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Ranking: View {
    @EnvironmentObject var settings : UserSettings
    @Binding var goRank:Bool
    @State var rk = Rk(rank:[])
    var body: some View {
        ZStack{
            Image("b3")
                .resizable()
                .ignoresSafeArea()
            
            ZStack{
                Color(red: 0.841, green: 0.936, blue: 0.965)
                    .ignoresSafeArea()
                VStack{
                    ScrollView{
                        HStack{
                            VStack{
                                Text(settings.lang == 0 ? "\nRanking" : "\n名次")
                                    .bold()
                                    .padding(settings.lang == 0 ? 0 : 5)
                                ForEach(rk.rank.indices,id: \.self){i in
                                    Text("\(i+1)")
                                        .padding(3)
                                }
                                Spacer()
                            }
                            VStack{
                                Text(settings.lang == 0 ? "\nName" : "\n暱稱")
                                    .bold()
                                    .padding(settings.lang == 0 ? 0 : 5)
                                ForEach(rk.rank.indices,id: \.self){i in
                                    Text(rk.rank[i].name)
                                        .padding(3)
                                }
                                Spacer()
                            }
                            VStack{
                                Text(settings.lang == 0 ? "\nScore" : "\n分數")
                                    .bold()
                                    .padding(settings.lang == 0 ? 0 : 5)
                                ForEach(rk.rank.indices,id: \.self){i in
                                    Text("\(rk.rank[i].score)")
                                        .padding(3)
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .font(.title)
                        .padding(9)
                    }
                }.frame(width: 300,height: 560)
                    .background(Color.white)
                    .cornerRadius(30)
            }
            .frame(width: 350,height: 600)
            .background(Color(red: 0.312, green: 0.495, blue: 0.59))
            .cornerRadius(30)
            HStack{
                Spacer()
                VStack{
                    Button {
                    goRank.toggle()
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
        }
        .onAppear{
            let db = Firestore.firestore()
            db.collection("排行榜").document("心臟病").addSnapshotListener{snapshot,error in
                guard let snapshot = snapshot else{return}
                guard let abcc = try? snapshot.data(as:Rk.self)else{return}
                rk = abcc
            }
        }
    }
}

struct Ranking_Previews: PreviewProvider {
    static var previews: some View {
        Ranking(goRank: .constant(true))
    }
}
