//
//  abc.swift
//  final
//
//  Created by User05 on 2023/4/26.
//
import SwiftUI
import Foundation
import FirebaseFirestoreSwift

class UserSettings: ObservableObject {
    @Published var id = UUID()
    @Published var name = "訪客"
    @Published var email = ""
    @Published var password = ""
    @Published var score = 0
    @Published var index = -1
    @Published var bgm = 1
    @Published var lang = 0
    @Published var sound = 0
}


struct gameStruct: Codable,Identifiable{
    @DocumentID var id: String?
    var enter:Bool
    var quit:Bool
    var player:[playerInfo]
    var score:[Int]
    var people:Int
    var card:Int
    var cardpool:[String]
    var nowTurn:Int
    var cardpoolNum:Int
    var playing:Bool
    var hit:Bool
    var losePlayer:[Int]
    var timmer:Bool
    var showAlert1:Bool
    var endGame:Bool
}

struct playerInfo: Codable,Identifiable{
    var name:String
    var id:UUID
    var score:Int
    var card:[String]
    var time:Double
}

struct Rk: Codable,Identifiable {
    @DocumentID var id: String?
    var rank:[loUserSettings]
}

struct loUserSettings: Codable,Identifiable {
    var id = UUID()
    var name = "訪客"
    var email = ""
    var password = ""
    var score = 0
    var index = -1
    var bgm = 1
    var lang = 0
    var sound = 0
}



