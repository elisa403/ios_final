//
//  setting.swift
//  final
//
//  Created by Elisa Chien on 2023/5/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct setting: View {
    @AppStorage("loSettings") var loSettings = Data()
    @EnvironmentObject var settings : UserSettings
    @Binding var goSet:Bool
    @State var abcc = loUserSettings()
    @State var music = true
    
    func saveSet(){
        do {
        loSettings = try JSONEncoder().encode(abcc)
        } catch {
        print(error)
        }
    }
    func loadSet(){
        guard !loSettings.isEmpty else { return }
        do {
        abcc = try JSONDecoder().decode(loUserSettings.self, from: loSettings)
        } catch {
        print(error)
        }
    }
    
    var body: some View {
        VStack{
            ZStack{
                Color(red: 0.841, green: 0.936, blue: 0.965)
                    .ignoresSafeArea()
                VStack{
                    Text(settings.lang == 0 ? "Settings" : "設定")
                        .bold()
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.white)
                    VStack{
                        Text(abcc.lang == 0 ? "Music: " : "音樂:")
                            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                            .bold()
                            .fontWeight(.bold)
                            .font(.title)
                        HStack{
                            Text("1")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.bgm == 0 ? Color.white : (abcc.bgm == 1 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white))
                                .cornerRadius(40)
                                .onTapGesture {
                                    music = true
                                    settings.bgm = 1
                                    abcc.bgm = 1
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].bgm = 1
                                        }
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    AVPlayer.bgQueuePlayer.pause()
                                    AVPlayer.setupBgMusic1()
                                    AVPlayer.bgQueuePlayer.play()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            Text("2")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.bgm == 0 ? Color.white : (abcc.bgm == 2 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white))
                                .cornerRadius(40)
                                .onTapGesture {
                                    music = true
                                    settings.bgm = 2
                                    abcc.bgm = 2
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].bgm = 2
                                        }
                                        
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    AVPlayer.bgQueuePlayer.pause()
                                    AVPlayer.setupBgMusic2()
                                    AVPlayer.bgQueuePlayer.play()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            
                        }
                        HStack{
                            Text("3")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.bgm == 0 ? Color.white : (abcc.bgm == 3 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white))
                                .cornerRadius(40)
                                .onTapGesture {
                                    music = true
                                    settings.bgm = 3
                                    abcc.bgm = 3
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].bgm = 3
                                        }
                                        
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    AVPlayer.bgQueuePlayer.pause()
                                    AVPlayer.setupBgMusic3()
                                    AVPlayer.bgQueuePlayer.play()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            Text("OFF")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.bgm != 0 ? Color.white : Color(red: 0.841, green: 0.936, blue: 0.965))
                                .cornerRadius(40)
                                .onTapGesture {
                                    music = false
                                    settings.bgm = 0
                                    abcc.bgm = 0
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].bgm = 0
                                            
                                        }
                                        
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    AVPlayer.bgQueuePlayer.pause()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                        }
                        Text(abcc.lang == 0 ? "Language: " : "語言:")
                            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                            .bold()
                            .fontWeight(.bold)
                            .font(.title)
                        HStack{
                            Text("English")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.lang == 0 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white)
                                .cornerRadius(40)
                                .onTapGesture {
                                    settings.lang = 0
                                    abcc.lang = 0
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].lang = 0
                                        }
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            Text("中文")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.lang == 1 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white)
                                .cornerRadius(40)
                                .onTapGesture {
                                    settings.lang = 1
                                    abcc.lang = 1
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].lang = 1
                                        }
                                        
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            
                        }
                        Text(abcc.lang == 0 ? "Sound: " : "音效:")
                            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                            .bold()
                            .fontWeight(.bold)
                            .font(.title)
                        HStack{
                            Text("ON")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.sound == 0 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white)
                                .cornerRadius(40)
                                .onTapGesture {
                                    settings.sound = 0
                                    abcc.sound = 0
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].sound = 0
                                        }
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            Text("OFF")
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .bold()
                                .fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100,height: 50)
                                .background(abcc.sound == 1 ? Color(red: 0.841, green: 0.936, blue: 0.965) : Color.white)
                                .cornerRadius(40)
                                .onTapGesture {
                                    settings.sound = 1
                                    abcc.sound = 1
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
                                        
                                        if let index = abc.rank.firstIndex(where: { $0.email == settings.email }) {
            //                                    print("找到了 \(em) 在索引 \(index)")
                                            abc.rank[index].sound = 1
                                        }
                                        
                                        do {
                                            try documentReference.setData(from: abc)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
                                )
                            
                        }
//                        HStack{
//                            Text("Sound effects: ")
//                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
//                                .bold()
//                                .fontWeight(.bold)
//                                .font(.title)
//                                .frame(width: 200)
//                            Text("ON")
//                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
//                                .bold()
//                                .fontWeight(.bold)
//                                .font(.title)
//                                .frame(width: 100,height: 50)
//                                .background(!soundd ? Color.white : Color(red: 0.841, green: 0.936, blue: 0.965))
//                                .cornerRadius(40)
//                                .onTapGesture {
//                                    soundd = true
//                                }
//                                .overlay{
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
//                                }
//                            Text("OFF")
//                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
//                                .bold()
//                                .fontWeight(.bold)
//                                .font(.title)
//                                .frame(width: 100,height: 50)
//                                .background(soundd ? Color.white : Color(red: 0.841, green: 0.936, blue: 0.965))
//                                .cornerRadius(40)
//                                .onTapGesture {
//                                    soundd = false
//                                }
//                                .overlay{
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
//                                }
//                        }
//                        HStack{
//                            Text("Switch style: ")
//                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
//                                .bold()
//                                .fontWeight(.bold)
//                                .font(.title)
//                                .frame(width: 200)
//                            Text("1")
//                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
//                                .bold()
//                                .fontWeight(.bold)
//                                .font(.title)
//                                .frame(width: 100,height: 50)
//                                .background(style ? Color.white : Color(red: 0.841, green: 0.936, blue: 0.965))
//                                .cornerRadius(40)
//                                .onTapGesture {
//                                    style = false
//                                }
//                                .overlay{
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
//                                }
//                            Text("2")
//                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
//                                .bold()
//                                .fontWeight(.bold)
//                                .font(.title)
//                                .frame(width: 100,height: 50)
//                                .background(!style ? Color.white : Color(red: 0.841, green: 0.936, blue: 0.965))
//                                .cornerRadius(40)
//                                .onTapGesture {
//                                    style = true
//                                }
//                                .overlay{
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .stroke(Color(red: 0.312, green: 0.495, blue: 0.59), lineWidth: 2.5)
//                                }
//                        }
                    }.frame(width: 230,height: 530)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .frame(width: 320,height: 600)
                .background(Color(red: 0.312, green: 0.495, blue: 0.59))
                .cornerRadius(30)
                HStack{
                    Spacer()
                    VStack{
                        Button {
                        goSet.toggle()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(20)
                            .foregroundColor(Color.white)
                        }
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: -10))
                        Spacer()
                    }
                }
                .frame(width: 320,height: 600)
                .cornerRadius(30)
            }
        }
        .onAppear{
            loadSet()
            settings.name = abcc.name
            settings.score = abcc.score
            settings.index = abcc.index
            settings.id = abcc.id
            settings.email = abcc.email
            settings.password = abcc.password
        }
    }
}

struct setting_Previews: PreviewProvider {
    static var previews: some View {
        setting(goSet: .constant(true))
    }
}
