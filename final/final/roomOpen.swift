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
    @State private var viewModel = roomOpenViewModel()
    
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
                if viewModel.numAppear{
                    Text(viewModel.num)
                        .font(.title)
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .frame(width: 160,height: 60)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                else{
                    Button(settings.lang == 0 ? "Open Room" : "開啟房間"){
    //                    viewModel.num = ["0000","0001","0002","0003","0004","0005","0006","0007"].randomElement()!
                        viewModel.num = "0000"
                        viewModel.createabc()
                        viewModel.numAppear = true
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
