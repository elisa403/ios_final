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
    @State private var viewModel = roomInputViewModel()
    
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
                TextField(settings.lang == 0 ? "Room Number" : "房間號碼", text: $viewModel.room)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding()
                Button(settings.lang == 0 ? "Enter" : "進入"){
                    let db = Firestore.firestore()
                        let documentReference =
                    db.collection(viewModel.room).document("牌")
                        documentReference.getDocument { document, error in
                            guard let document,
                                  document.exists,
                                  var abc = try? document.data(as: gameStruct.self)
                            else {
                                return
                            }
                            viewModel.playinfo.id = settings.id
                            viewModel.playinfo.name = settings.name
                            viewModel.playinfo.score = settings.score
                            abc.player += [viewModel.playinfo]
                            if(!abc.playing){
                                settings.index = abc.player.count-1
                                viewModel.abcc.index = abc.player.count-1
                                
                                do {loSettings = try JSONEncoder().encode(viewModel.abcc)} catch {print(error)}
                                
                                do {
                                    try documentReference.setData(from: abc)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        viewModel.enterRoom.toggle()
                    }
                    
                }
                .fullScreenCover(isPresented: $viewModel.enterRoom, content: {waitingRoom(enterRoom: $viewModel.enterRoom,room: $viewModel.room)})
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
            guard !loSettings.isEmpty else { return }
            do {
                viewModel.abcc = try JSONDecoder().decode(loUserSettings.self, from: loSettings)
            } catch {
            print(error)
            }
        }
    }
}

//struct roomInput_Previews: PreviewProvider {
//    static var previews: some View {
//        roomInput(inputRoom:.constant(true))
//    }
//}
