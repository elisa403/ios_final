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

struct register: View {
    @AppStorage("loSettings") var loSettings = Data()
    @EnvironmentObject var settings : UserSettings
    @Binding var goRegister:Bool
    @Binding var log:Bool
    @State private var viewModel = registerViewModel()
    
    var body: some View {
        ZStack{
            Image("b3")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text(settings.lang == 0 ? "Register" : "註冊")
                    .font(.title)
                    .bold()
                TextField(settings.lang == 0 ? "Nickname" : "暱稱", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("e-mail", text: $viewModel.em)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField(settings.lang == 0 ? "Password" : "密碼", text: $viewModel.pass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack{
                    Button(settings.lang == 0 ? "Return" : "返回"){
                        goRegister = false
                    }
                    Button(settings.lang == 0 ? "Register" : "註冊"){
                        Auth.auth().createUser(withEmail: viewModel.em, password: viewModel.pass){result,error in
                            guard let user = result?.user,
                                  error == nil else{
                                viewModel.showAlert.toggle()
                                viewModel.regiSuccess = false
                                return
                            }
                            if let user = Auth.auth().currentUser {
                                settings.name = viewModel.name
                                settings.email = viewModel.em
                                settings.password = viewModel.pass
                                
                                viewModel.abcc.name = viewModel.name
                                viewModel.abcc.email = viewModel.em
                                viewModel.abcc.password = viewModel.pass
                                viewModel.abcc.score = 0
                                viewModel.abcc.bgm = settings.bgm
                                
                                viewModel.changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                viewModel.changeRequest?.displayName = viewModel.name
    //                            changeRequest?.hashValue = settings.score
                                viewModel.changeRequest?.commitChanges(completion: { error in
                                    guard error == nil else {
                                        viewModel.showAlert.toggle()
                                        viewModel.regiSuccess = false
    //                                    print(error?.localizedDescription)
                                        return
                                    }
                                    
                                    do {loSettings = try JSONEncoder().encode(viewModel.abcc)} catch {print(error)}
                                    
                                    let db = Firestore.firestore()
                                        let documentReference =
                                    db.collection("排行榜").document("心臟病")
                                    documentReference.getDocument { document, error in
                                        guard let document,
                                              document.exists,
                                              var abc = try? document.data(as: Rk.self)
                                        else {
                                            return
                                        }
                                        
                                        abc.rank += [viewModel.abcc]
                                        abc.rank.sort { $0.score > $1.score }
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    viewModel.showAlert.toggle()
                                    viewModel.regiSuccess = true
                                    log = true
    //                                print("\(user.displayName) login")
                                })
                            } else {
                                viewModel.showAlert.toggle()
                                viewModel.regiSuccess = false
                            }
                        }
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(
                            title: Text(viewModel.regiSuccess ? "註冊成功！" : "信息錯誤！"),
                            dismissButton: .cancel(Text("確認")) {goRegister.toggle()}
                        )
                    }
                }
            }
            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
            .frame(width: 320 ,height: 500)
            .background(Color.white)
            .cornerRadius(30)
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
}
struct register_Previews: PreviewProvider {
    static var previews: some View {
        register(goRegister:.constant(true),log:.constant(true))
    }
}
