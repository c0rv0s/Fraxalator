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
                        ForEach(row ..< row + 2) { col in
                            Button(action: {
                                self.score.rules[self.letter]! += self.score.letters[row * 2 + col]
                            }) {
                                Text(self.score.letters[row * 2 + col])
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
                    .padding()
                }
                Button(action: {
                    self.score.rules[self.letter]! = String(self.score.rules[self.letter]!.dropLast())
                }) {
                    Image(systemName: "delete.left")
                        .padding()
                        .frame(width: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                    )
                }
                .padding()
            }
    }
    
}

//struct SetRule_Previews: PreviewProvider {
//    static var previews: some View {
//        SetRule(letter: "A", score: )
//    }
//}
