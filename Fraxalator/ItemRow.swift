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
        HStack{
            if (letter == "S") {
                Image(systemName: "music.note")
                Text(":")
                if (score.seed == "") {
                    Text("Tap to enter seed")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.gray)
                        .onTapGesture {
                            self.pickRule.toggle()
                        }
                        .sheet(isPresented: $pickRule) {
                            SetSeed(score: self.$score)
                        }
                }
                else {
                    Text(self.score.seed)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            self.pickRule.toggle()
                        }
                        .sheet(isPresented: $pickRule) {
                            SetSeed(score: self.$score)
                        }
                }
            }
            else {
                Text(letter + ": ")
                
                if (score.rules[self.letter] == "") {
                    Text("Tap to enter a rule")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.gray)
                        .onTapGesture {
                            self.pickRule.toggle()
                        }
                        .sheet(isPresented: $pickRule) {
                            SetRule(letter: self.letter, score: self.$score)
                        }
                }
                else {
                    Text(self.score.rules[self.letter] ?? "")
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            self.pickRule.toggle()
                        }
                        .sheet(isPresented: $pickRule) {
                            SetRule(letter: self.letter, score: self.$score)
                        }
                }
            }
        }
    }
}

//struct ItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow(letter: "A", score: <#Binding<Score>#>)
//    }
//}
