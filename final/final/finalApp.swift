//
//  finalApp.swift
//  final
//
//  Created by User05 on 2023/4/19.
//

import SwiftUI
import Firebase

@main
struct finalApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
//            roomInput(inputRoom: .constant(true))
            ContentView()
//            waitingRoom(enterRoom: .constant(true), room: .constant("0003"))
        }
    }
}
