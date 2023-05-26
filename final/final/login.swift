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

struct login: View {
    @AppStorage("loSettings") var loSettings = Data()
    @EnvironmentObject var settings : UserSettings
    @Binding var goLogin:Bool
    @Binding var log:Bool
    @State var retrungame = false
    @State var em = ""
    @State var pass = ""
    @State var showAlert = false
    @State var loginSuccess = false
    @State var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    @State var abcc = loUserSettings()
    
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
                Text("登入")
                    .font(.title)
                    .bold()
                TextField("e-mail", text: $em)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("密碼", text: $pass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack{
                    Button("返回"){
                        goLogin = false
                    }
                    Button("登入"){
                        Auth.auth().signIn(withEmail: em, password: pass){result,error in
                            guard error == nil else{
                                showAlert.toggle()
                                return
                            }
                            if let user = Auth.auth().currentUser{
                                settings.name = user.displayName!
                                settings.email = em
                                settings.password = pass
                            }
                            
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
                                
                                if let index = abc.rank.firstIndex(where: { $0.email == em }) {
    //                                    print("找到了 \(em) 在索引 \(index)")
                                    settings.score = abc.rank[index].score
                                    abcc.name = abc.rank[index].name
                                    abcc.score = abc.rank[index].score
                                    abcc.id = abc.rank[index].id
                                    abcc.email = abc.rank[index].email
                                    abcc.password = abc.rank[index].password
                                    abcc.bgm = abc.rank[index].bgm
                                    saveSet()
                                }
                                saveSet()
                            }
                            
                            showAlert.toggle()
                            loginSuccess = true
                            log = loginSuccess
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(loginSuccess ? " 登入成功！\n歡迎回來" : "登入失敗！")
                            ,dismissButton: .cancel(Text("確認")) {goLogin.toggle()}
                        )
                    }
                }
            }
            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
            .frame(width: 320 ,height: 490)
            .background(Color.white)
            .cornerRadius(30)
        }

    }
}

struct login_Previews: PreviewProvider {
    static var previews: some View {
        login(goLogin:.constant(true),log:.constant(true))
    }
}
