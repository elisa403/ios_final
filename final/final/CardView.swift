//
//  CardView.swift
//  Demo
//
//  Created by Peter Pan on 2023/5/9.
//

import SwiftUI
import AVFoundation

struct CardView: View {
    let cardImage: Image
    let cardBackImage: Image
    @Binding var isFaceUp: Bool
//    @Binding var x:CGFloat
//    @Binding var y:CGFloat

    var body: some View {
        let cardWidth: CGFloat = 100
        let cardHeight: CGFloat = 150

        ZStack {
            cardImage
                .resizable()
                .frame(width: cardWidth, height: cardHeight)
                .opacity(isFaceUp ? 1 : 0)
                .cornerRadius(10)
            cardBackImage
                .resizable()
                .frame(width: cardWidth, height: cardHeight)
                .opacity(isFaceUp ? 0 : 1)
                .cornerRadius(10)
        }
        .rotation3DEffect(
            .degrees(isFaceUp ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        //.animation(.linear(duration: 5), value: isFaceUp)
        .animation(.linear(duration: 0.1), value: isFaceUp)
        .onTapGesture {
            AVPlayer.sharedFlipPlayer.playFromStart()
            withAnimation {
                isFaceUp = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                isFaceUp = false
            }
        }
    }
}

//
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
