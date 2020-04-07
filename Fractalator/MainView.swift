//
//  Home.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/6/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var score = Score()
    @State var showingScore = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(0..<self.score.letters.count) {
                        ItemRow(letter: self.score.letters[$0], score: self.$score)
                    }
                    ItemRow(letter: "S", score: self.$score)
                    Stepper(value: $score.iterations) {
                        Text("Iterations: ").fontWeight(.heavy)
                        Text("\(self.score.iterations)")
                    }
                }
                
                Section {
                    Button(action: {
                        self.score.generateScore()
                        self.showingScore.toggle()
                        self.score.playScore()
                    }) {
                        Text("Create")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.blue)
                    }
                    .sheet(isPresented: $showingScore) {
                        VStack {
                            Text(self.score.fractalScore)
                                .padding()
                            
                            Button(action: {
                                if self.score.playing {
                                    self.score.pauseScore()
                                }
                                else {
                                    self.score.playScore()
                                }
                            }) {
                                if self.score.playing {
                                    Image(systemName: "pause")
                                }
                                else {
                                    Image(systemName: "play")
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Fractal Rules"))
            .listStyle(GroupedListStyle())
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
