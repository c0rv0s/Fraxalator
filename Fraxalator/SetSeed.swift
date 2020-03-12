//
//  SetSeed.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/10/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import SwiftUI

struct SetSeed: View {
    @Binding var score: Score
    
    var body: some View {
            VStack {
                if (self.score.seed == "") {
                    Text("Enter a seed:")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 50)
                }
                else {
                    Text(self.score.seed)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                }
                ForEach(0 ..< 4) { row in
                    HStack {
                        ForEach(0 ..< 2) { col in
                            if (row == 3 && col == 1) {
                                Button(action: {
                                    self.score.seed = String(self.score.seed.dropLast())
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
                                SeedLetterButton(row: row, col: col, score: self.$score)
                            }
                        }
                    }
                    .padding()
                }
                
            }
    }
    
}

struct SeedLetterButton: View {
    var row: Int
    var col: Int
    @Binding var score: Score
    
    var body: some View {
        Button(action: {
            self.score.seed += self.score.letters[2 * self.row + self.col]
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

//struct SetSeed_Previews: PreviewProvider {
//    static var previews: some View {
//        SetSeed()
//    }
//}
