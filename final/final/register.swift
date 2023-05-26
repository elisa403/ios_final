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
    @State var str = ""
    @State var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    @State var em = ""
    @State var pass = ""
    @State var name = ""
    @State var showAlert  = false
    @State var regiSuccess = false
    @State var renew  = false
    @State var retrungame = false
    @State var abcc = loUserSettings()
    
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
            Image("b3")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text(settings.lang == 0 ? "Register" : "註冊")
                    .font(.title)
                    .bold()
                TextField(settings.lang == 0 ? "Nickname" : "暱稱", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("e-mail", text: $em)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField(settings.lang == 0 ? "Password" : "密碼", text: $pass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack{
                    Button(settings.lang == 0 ? "Return" : "返回"){
                        goRegister = false
                    }
                    Button(settings.lang == 0 ? "Register" : "註冊"){
                        Auth.auth().createUser(withEmail: em, password: pass){result,error in
                            guard let user = result?.user,
                                  error == nil else{
                                showAlert.toggle()
                                regiSuccess = false
                                return
                            }
                            if let user = Auth.auth().currentUser {
                                settings.name = name
                                settings.email = em
                                settings.password = pass
                                
                                abcc.name = name
                                abcc.email = em
                                abcc.password = pass
                                abcc.score = 0
                                abcc.bgm = settings.bgm
                                
                                changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = name
    //                            changeRequest?.hashValue = settings.score
                                changeRequest?.commitChanges(completion: { error in
                                    guard error == nil else {
                                        showAlert.toggle()
                                        regiSuccess = false
    //                                    print(error?.localizedDescription)
                                        return
                                    }
                                    
                                    saveSet()
                                    
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
                                        
                                        abc.rank += [abcc]
                                        abc.rank.sort { $0.score > $1.score }
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    showAlert.toggle()
                                    regiSuccess = true
                                    log = true
    //                                print("\(user.displayName) login")
                                })
                            } else {
                                showAlert.toggle()
                                regiSuccess = false
                            }
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(regiSuccess ? "註冊成功！" : "信息錯誤！"),
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
                loadSet()
            }
        }
    }
}
struct register_Previews: PreviewProvider {
    static var previews: some View {
        register(goRegister:.constant(true),log:.constant(true))
    }
}
