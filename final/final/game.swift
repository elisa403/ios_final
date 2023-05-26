//
//  game.swift
//  final
//
//  Created by Elisa Chien on 2023/5/5.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation


struct game: View {
    @AppStorage("loSettings") private var loSettings = Data()
    @EnvironmentObject var settings : UserSettings
    @Binding var enterGame:Bool
    @Binding var room:String
    @State var now = gameStruct(enter:false,quit:false,player: [],score: [], people: 0, card: 1,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: true,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    @State var goTop = false
    @State var quit = false
    @State var hit = false
    @State var timmer = false
    @State var showAlert2 = false
    @State var showAlert1 = false
    @State var num = 0
    @State var str = ""
    @State var maxTimeIndex = [0]
    @State var losepeople = 0
    var array = ["s,1","s,2","s,3","s,4","s,5","s,6","s,7","s,8","s,9","s,10","s,11","s,12","s,13","h,1","h,2","h,3","h,4","h,5","h,6","h,7","h,8","h,9","h,10","h,11","h,12","h,13","d,1","d,2","d,3","d,4","d,5","d,6","d,7","d,8","d,9","d,10","d,11","d,12","d,13","c,1","c,2","c,3","c,4","c,5","c,6","c,7","c,8","c,9","c,10","c,11","c,12","c,13"]
    @State var arrayRandom = []
    @State var abcc = loUserSettings()
    @State private var isFaceUp = false
    @State private var x:CGFloat = 0.8
    @State private var y:CGFloat = 0.0
    
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
        GeometryReader{geo in
            ZStack{
                Image("b3")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Text(settings.lang == 0 ? "Room:" + room : "房間:" + room)
                            .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                            .frame(width: 90,height: 15)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(10)
                        Spacer()
                        Button(action: {
                            now.quit = true
                            now.enter = false
                            now.playing = false
                            createabc()
                            goTop = now.quit
                            abcc.name = settings.name
                            abcc.score = settings.score
                            abcc.email = settings.email
                            abcc.password = settings.password
                            abcc.bgm = settings.bgm
                            abcc.lang = settings.lang
                            abcc.id = settings.id
                            saveSet()
                        }, label: {
                            Text(settings.lang == 0 ? "Quit" : "離開房間")
                            .font(.title3)
                        })
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .frame(width: 90,height: 15)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                        .padding(10)
                    }
                    HStack{
                        ForEach(now.player.indices,id: \.self){i in
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 0.312, green: 0.495, blue: 0.59),lineWidth: 5)
                                .frame(height: 100)
                                .background(i == now.nowTurn ? Color(red: 221/255, green: 230/255, blue: 237/255) : Color.white)
                                .cornerRadius(30)
                                .overlay(
                                    VStack{
                                        Text(i == settings.index ? now.player[i].name + (settings.lang == 0 ? "(You)" : "(你)") : now.player[i].name)
                                        Text(settings.lang == 0 ? "Score:\(now.player[i].score)" : "累積分數:\(now.player[i].score)")
                                        Text(settings.lang == 0 ? "\(now.player[i].card.count) Card Left" : "剩下\(now.player[i].card.count)張")
                                        if(now.cardpoolNum == now.card && now.hit && hit){
                                            if(now.losePlayer.count == now.player.count){
                                                if(now.losePlayer[now.losePlayer.count-1] == i){
                                                    Text("+++++++")
                                                }
                                            }
                                        }
                                        else if((now.cardpoolNum == now.card && now.showAlert1 && now.losePlayer[0] == i) || (showAlert1 && now.nowTurn == i)){
                                            Text("+++++++")
                                        }
                                    }
                                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                )
                        }
                    }
                    .padding()
                    
                    Text(settings.lang == 0 ? "Point:\(now.card)" : "點數:\(now.card)")
//                    Text(settings.lang == 0 ? "Point:20" : "點數:20")
                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                        .frame(width: 70,height: 15)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                    if(now.cardpool.count == 0){
                        Image("back1")
                            .resizable()
                            .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                            .cornerRadius(10)
                    }
                    else{
        //                Text("卡池："+(now.cardpool[now.cardpool.count-1]))
        //                Text("數字：\(now.cardpoolNum)")
                        Image(now.cardpool[now.cardpool.count-1])  //卡池的卡
                            .resizable()
                            .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                            .cornerRadius(10)
                        
                    }
                    if(now.timmer){
                        Text(settings.lang == 0 ? "Countdown to 2 seconds!" : "倒數2秒開始！")
                            .foregroundColor(Color.white)
                    }
                
                    if(now.cardpoolNum == now.card){
                        if((now.hit && hit) || (now.showAlert1)){
                            HStack{
                                Image("back1")
                                    .resizable()
                                    .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                                    .cornerRadius(10)
                                VStack{
                                    Text(settings.lang == 0 ? "Hit!" : "拍!")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                        .frame(width: 50,height: 50)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(50)
                                        .padding(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color.white, lineWidth: 2.5)
                                        )
                                    if(now.player.count > settings.index){
                                        VStack{
                                            Text(settings.lang == 0 ? "Card Pool: \(now.cardpool.count)" : "卡池累積\(now.cardpool.count)張")
                                            Text(settings.lang == 0 ? "\(now.player[settings.index].card.count) Card Left" : "剩下\(now.player[settings.index].card.count)張")
                                        }
                                        .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                        .frame(width: 130,height: 50)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        
                                    }
                                }
                            }
                        }
                        else{
                        HStack{
                            ZStack{
                                Image("back1")
                                    .resizable()
                                    .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                                    .cornerRadius(10)
                                Button(action: {
                                    if(settings.sound == 0){
                                        AVPlayer.sharedbubuPlayer.playFromStart()
                                    }
                                    showAlert1 = true
                                    now.showAlert1 = true
                                    now.losePlayer = [settings.index]
                                    createabc()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        showAlert1 = false
                                        now.showAlert1 = false
                                        for j in(0..<now.cardpool.count){
                                            now.player[settings.index].card += [now.cardpool[j]]
                                        }
                                        now.cardpoolNum = -1
                                        now.cardpool = []
                                        now.timmer = false
                                        now.losePlayer = []
                                        createabc()
                                    }
                                }, label: {
                                    Image("back1")
                                        .resizable()
                                        .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                                        .cornerRadius(10)
                                    //詐騙出牌
                                })
                            }
                            VStack{
                                Button(action: {
                                    if(settings.sound == 0){
                                        AVPlayer.sharedbubuPlayer.playFromStart()
                                    }
                                    
                                    now.losePlayer += [settings.index]
                                    now.timmer = true
                                    now.hit = true
                                    createabc()
                                    hit = true
                                    if(now.timmer){
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            now.timmer = false
                                            for i in (0..<now.player.count){
                                                if(now.losePlayer.index(of: i) == nil){
                                                    now.losePlayer += [i]
                                                }
                                            }
                                            createabc()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                for j in(0..<now.cardpool.count){
                                                    now.player[now.losePlayer[now.losePlayer.count-1]].card += [now.cardpool[j]]
                                                }
                                                now.cardpoolNum = -1
                                                now.cardpool = []
                                                now.hit = false
                                                hit = false
                                                now.losePlayer = []
                                                createabc()
                                           }
                                        }
                                    }
                                }, label: {
                                    Text(settings.lang == 0 ? "Hit" : "拍!")
                                        .font(.title)
                                        .bold()
                                })
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .frame(width: 50,height: 50)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(50)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.white, lineWidth: 2.5)
                                )
                                if(now.player.count > settings.index){
                                    VStack{
                                        Text(settings.lang == 0 ? "Card Pool: \(now.cardpool.count)" : "卡池累積\(now.cardpool.count)張")
                                        Text(settings.lang == 0 ? "\(now.player[settings.index].card.count) Card Left" : "剩下\(now.player[settings.index].card.count)張")
                                    }
                                    .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                    .frame(width: 130,height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                                }
                            }
                        }
                    }
                    else{
                        HStack{
                            if(settings.index == -1){
                                Text("觀戰模式")
                                    .foregroundColor(Color.white)
                            }
                            else if(now.nowTurn == settings.index){
//                                    //出牌
                                ZStack{
                                    Image(now.player.count > settings.index ? now.player[settings.index].card[0] : "back1")
                                        .resizable()
                                        .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                                        .opacity(isFaceUp ? 1 : 0)
                                        .cornerRadius(10)
                                    Image("back1")
                                        .resizable()
                                        .frame(width: geo.size.width/3.3, height: geo.size.width*3/6.6)
                                        .opacity(isFaceUp ? 0 : 1)
                                        .cornerRadius(10)
                                }
                                .rotation3DEffect(
                                    .degrees(isFaceUp ? 0 : 180),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .animation(.linear(duration: 0.1), value: isFaceUp)
                                .onTapGesture{
                                    withAnimation{
                                        isFaceUp = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                        isFaceUp = false
                                        now.card = (now.card)%13+1
                                        now.nowTurn = (now.nowTurn+1)%now.player.count
                                        for i in 0...now.player.count{
                                            if now.player[i].id == settings.id{
                                                now.cardpool += [now.player[i].card[0]]
                                                now.player[i].card.remove(at: 0)
                                                break
                                            }
                                        }
                                        let a = now.cardpool[now.cardpool.count-1].split(separator: ",")
                                        num = Int(a[1])!
                                        now.cardpoolNum = num
                                        if(now.player[settings.index].card.count == 0){
                                            AVPlayer.sharedWinPlayer.playFromStart()
                                            now.endGame = true
                                            now.player[settings.index].score += 20
                                            settings.score = now.player[settings.index].score
                                            abcc.name = settings.name
                                            abcc.score = settings.score
                                            abcc.index = settings.index
                                            abcc.id = settings.id
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
                                                    abc.rank[index].score = settings.score
                                                    abc.rank.sort { $0.score > $1.score }
                                                }
                                                do {
                                                    try documentReference.setData(from: abc)
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }
                                        else if(settings.sound == 0){
                                            AVPlayer.sharedFlipPlayer.playFromStart()
                                        }
                                        createabc()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
    //                                        isFaceUp = false
                                            now.endGame = false
                                            createabc()
                                        }
                                    }
                                }
                            }
                            else{
                                Image("back1")
                                    .resizable()
                                    .frame(width: geo.size.width/4, height: geo.size.width*3/8)
                                    .cornerRadius(10)
                            }
                            VStack{
                                
                                Button(action: {
                                    if(settings.sound == 0){
                                        AVPlayer.sharedbubuPlayer.playFromStart()
                                    }
                                    for j in(0..<now.cardpool.count){
                                        now.player[settings.index].card += [now.cardpool[j]]
                                    }
                                    now.cardpoolNum = -1
                                    now.cardpool = []
                                    createabc()
                                    showAlert1 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                        showAlert1 = false
                                    }
                                }, label: {
                                    Text(settings.lang == 0 ? "Hit!" : "拍!")
                                        .font(.title)
                                        .bold()
                                })
                                .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                .frame(width: 50,height: 50)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(50)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.white, lineWidth: 2.5)
                                )
                                
                                if(now.player.count > settings.index){
                                    VStack{
                                        Text(settings.lang == 0 ? "Card Pool: \(now.cardpool.count)" : "卡池累積\(now.cardpool.count)張")
                                        if(now.player.count > settings.index){
                                            Text(settings.lang == 0 ? "\(now.player[settings.index].card.count) Card Left" : "剩下\(now.player[settings.index].card.count)張")
                                        }
                                    }
                                    .foregroundColor(Color(red: 0.312, green: 0.495, blue: 0.59))
                                    .frame(width: 130,height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                }
            }
            
        }
        .onAppear(perform: {
            loadSet()
            let db = Firestore.firestore()
            db.collection(room).document("牌").addSnapshotListener{snapshot,error in
                guard let snapshot = snapshot else{return}
                guard let abcc = try? snapshot.data(as:gameStruct.self)else{return}
                now = abcc
                goTop = now.quit
                enterGame = now.enter
            }
        })
        .alert(isPresented: $showAlert1) {
            Alert(
                title: Text(settings.lang == 0 ? "QQ" : "阿喔～慘了～牌都是你的了～"),
                dismissButton: .cancel(Text(settings.lang == 0 ? "Access" : "確認")) {showAlert1 = false}
            )
        }
        .alert(isPresented: $now.endGame) {
            Alert(
                //                if(now.player.count > settings.index){
                //                    if(now.player[settings.index].card.count == 0){AVPlayer.sharedWinPlayer.playFromStart()}
                //                    else{AVPlayer.sharedLosePlayer.playFromStart()}
                //                }
                //                AVPlayer.sharedWinPlayer.playFromStart()
                title: Text(now.player.count > settings.index ? (now.player[settings.index].card.count == 0 ? "win" : "lose") : ""),
                dismissButton: .cancel(Text(settings.lang == 0 ? "Access" : "確認")) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        now.quit = true
                        now.enter = false
                        now.playing = false
                        createabc()
                        enterGame = now.enter
                        goTop = now.quit
                    }
                    
                }
            )
        }
        
        .font(.body)
//        .fullScreenCover(isPresented: $now.endGame, content: {winlose(room:$room,goTop:$goTop,enterGame:$enterGame)})
        .environmentObject(settings)
        
    }
}

struct game_Previews: PreviewProvider {
    static var previews: some View {
        game(enterGame:.constant(true),room: .constant("0001"))
    }
}
