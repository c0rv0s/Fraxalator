//
//  ItemRow.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/6/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import SwiftUI

struct ItemRow: View {
    var letter: String
    @State var pickRule = false
    @Binding var score: Score
    
    var body: some View {
        HStack {
            if (letter == "S") {
                Image(systemName: "music.note")
                Text(":")
                Spacer()
                if (score.seed == "") {
                    Text("Tap to enter seed")
                        .foregroundColor(Color.gray)
                }
                else {
                    Text(self.score.seed)
                }
            }
            else {
                Text(letter + ": ").fontWeight(.heavy)
                Spacer()
                Text(self.score.rules[self.letter] ?? "")
            }
            Image(systemName: "pencil").foregroundColor(Color(UIColor.brown))
            Spacer()
        }
        .onTapGesture {
            self.pickRule.toggle()
        }
        .sheet(isPresented: $pickRule) {
            if (self.letter == "S") {
                SetSeed(score: self.$score)
            }
            else {
                SetRule(letter: self.letter, score: self.$score)
            }
        }
    }
}

//struct ItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow(letter: "A", score: <#Binding<Score>#>)
//    }
//}
