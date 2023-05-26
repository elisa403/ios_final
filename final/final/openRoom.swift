//
//  openRoom.swift
//  final
//
//  Created by Elisa Chien on 2023/5/12.
//

import SwiftUI

struct openRoom: View {
    @Binding var openRoom:Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct openRoom_Previews: PreviewProvider {
    static var previews: some View {
        openRoom(openRoom: .constant(true))
    }
}
