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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<self.score.letters.count) {
                    ItemRow(letter: self.score.letters[$0], score: self.$score)
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
