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
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(0..<self.score.letters.count) {
                    ItemRow(letter: self.score.letters[$0], score: self.$score)
                }
                ItemRow(letter: "S", score: self.$score)
                Button(action: {
                    self.score.generateScore()
                    self.showingAlert.toggle()
//                    playScore(score: self.score)
                }) {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Score"), message: Text(self.score.fractalScore), dismissButton: .default(Text("Done")))
                }
            }
            .navigationBarTitle(Text("Fractal Rules"))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
