//
//  SetRule.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/10/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import SwiftUI

struct SetRule: View {
    var letter: String
    @Binding var score: Score
    
    var body: some View {
            VStack {
                if (score.rules[self.letter] == "") {
                    Text("Replace \(letter) with:")
                        .font(.title)
//                        .font(.system(.title, design: .serif))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 50)
                }
                else {
                    Text(score.rules[self.letter] ?? "")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                }
                ForEach(0 ..< 4) { row in
                    HStack {
                        ForEach(0 ..< 2) { col in
                            if (row == 3 && col == 1) {
                                Button(action: {
                                    self.score.rules[self.letter]! = String(self.score.rules[self.letter]!.dropLast())
                                }) {
                                    Image(systemName: "delete.left")
                                        .padding()
                                        .frame(width: 120)
                                        .accentColor(.red)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.red, lineWidth: 1)
                                    )
                                }
                                .padding(.horizontal, 15)
                            }
                            else {
                                LetterButton(row: row, col: col, letter: self.letter, score: self.$score)
                            }
                        }
                    }
                    .padding()
                }
                
            }
    }
    
}

struct LetterButton: View {
    var row: Int
    var col: Int
    var letter: String
    @Binding var score: Score
    
    var body: some View {
        Button(action: {
            self.score.rules[self.letter]! += self.score.letters[2 * self.row + self.col]
        }) {
            Text(self.score.letters[2 * self.row + self.col])
                .padding()
                .frame(width: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
            )
        }
        .padding(.horizontal, 15)
    }
}

//struct SetRule_Previews: PreviewProvider {
//    static var previews: some View {
//        SetRule(letter: "A", score: )
//    }
//}
