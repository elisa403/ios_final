import Foundation
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension AVPlayer {
    static let sharedFlipPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "flip", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static let sharedWinPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "win", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static let sharedLosePlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "lose", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    static let sharedpaiPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "pai", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    static let sharedbubuPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "bubu", withExtension:
        "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()

    func playFromStart() {
        seek(to: .zero)
        play()
    }
    
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    static func setupBgMusic3() {
        guard let url = Bundle.main.url(forResource: "bgm3",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    static func setupBgMusic1() {
        guard let url = Bundle.main.url(forResource: "bgm1",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    static func setupBgMusic2() {
        guard let url = Bundle.main.url(forResource: "bgm2",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}

struct contenViewModel {
    
    var log = false
    var inputRoom = false
    var goRegister = false
    var goLogin = false
    var openRoom = false
    var abcc = loUserSettings()
    var goRank = false
    var goSet = false
    var enterRoom = false
    var playinfo = playerInfo(name: "", id: UUID(),score: 0,card: [],time: 10000.0)
    var room = "0008"
    
}

struct settingViewModel {
    var abcc = loUserSettings()
    var music = true
}

struct loginViewModel {
    var retrungame = false
    var em = ""
    var pass = ""
    var showAlert = false
    var loginSuccess = false
    var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    var abcc = loUserSettings()
}

struct registerViewModel {
    var str = ""
    var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    var em = ""
    var pass = ""
    var name = ""
    var showAlert  = false
    var regiSuccess = false
    var renew  = false
    var retrungame = false
    var abcc = loUserSettings()
}

struct roomOpenViewModel{
    var num = ""
    var numAppear = false
    var rk = Rk(rank:[])
    var now = gameStruct(enter:false,quit:true,player: [], score: [], people: 0, card: 1,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    func createabc(){
        let db = Firestore.firestore()
        
        do{
            try
                db.collection(num).document("牌").setData(from: now)
        }catch{
            print(error)
        }
    }
}

struct roomInputViewModel{
    var room = "0000"
    var enterRoom = false
    var showAlert = false
    var playinfo = playerInfo(name: "", id: UUID(),score: 0,card: [],time: 10000.0)
    var now = gameStruct(enter:false,quit: false,player: [],score: [], people: 0, card: 0,cardpool: [""],nowTurn: 0,cardpoolNum: 0,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    var abcc = loUserSettings()
    
    func createabc(){
        let db = Firestore.firestore()
        
        do{
            try
                db.collection(room).document("牌").setData(from: now)
        }catch{
            print(error)
        }
    }
}

struct waitingRoomViewModel{
    var now = gameStruct(enter:false,quit: true,player: [],score: [], people: 0, card: 0,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: false,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    var goTop = false
    var enterGame = false
    var cardPer = 0
    var array = ["s,1","s,2","s,3","s,4","s,5","s,6","s,7","s,8","s,9","s,10","s,11","s,12","s,13","h,1","h,2","h,3","h,4","h,5","h,6","h,7","h,8","h,9","h,10","h,11","h,12","h,13","d,1","d,2","d,3","d,4","d,5","d,6","d,7","d,8","d,9","d,10","d,11","d,12","d,13","c,1","c,2","c,3","c,4","c,5","c,6","c,7","c,8","c,9","c,10","c,11","c,12","c,13","s,1","s,2","s,3","s,4","s,5","s,6","s,7","s,8","s,9","s,10","s,11","s,12","s,13","h,1","h,2","h,3","h,4","h,5","h,6","h,7","h,8","h,9","h,10","h,11","h,12","h,13","d,1","d,2","d,3","d,4","d,5","d,6","d,7","d,8","d,9","d,10","d,11","d,12","d,13","c,1","c,2","c,3","c,4","c,5","c,6","c,7","c,8","c,9","c,10","c,11","c,12","c,13"]
//    var array = ["s,2","d,2","c,2","h,2"]
}

struct gameViewModel{
    var now = gameStruct(enter:false,quit:false,player: [],score: [], people: 0, card: 1,cardpool: [""],nowTurn: 0,cardpoolNum: -1,playing: true,hit: false,losePlayer: [],timmer: false,showAlert1: false,endGame: false)
    var goTop = false
    var quit = false
    var hit = false
    var timmer = false
    var showAlert2 = false
    var showAlert1 = false
    var num = 0
    var str = ""
    var maxTimeIndex = [0]
    var losepeople = 0
    var array = ["s,1","s,2","s,3","s,4","s,5","s,6","s,7","s,8","s,9","s,10","s,11","s,12","s,13","h,1","h,2","h,3","h,4","h,5","h,6","h,7","h,8","h,9","h,10","h,11","h,12","h,13","d,1","d,2","d,3","d,4","d,5","d,6","d,7","d,8","d,9","d,10","d,11","d,12","d,13","c,1","c,2","c,3","c,4","c,5","c,6","c,7","c,8","c,9","c,10","c,11","c,12","c,13","s,1","s,2","s,3","s,4","s,5","s,6","s,7","s,8","s,9","s,10","s,11","s,12","s,13","h,1","h,2","h,3","h,4","h,5","h,6","h,7","h,8","h,9","h,10","h,11","h,12","h,13","d,1","d,2","d,3","d,4","d,5","d,6","d,7","d,8","d,9","d,10","d,11","d,12","d,13","c,1","c,2","c,3","c,4","c,5","c,6","c,7","c,8","c,9","c,10","c,11","c,12","c,13"]
    var abcc = loUserSettings()
    private var isFaceUp = false
    private var x:CGFloat = 0.8
    private var y:CGFloat = 0.0
    
}

struct rankVM{
    var rk = Rk(rank:[])
}
