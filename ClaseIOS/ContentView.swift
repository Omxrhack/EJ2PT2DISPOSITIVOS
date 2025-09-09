//
//  ContentView.swift
//  ClaseIOS
//
//  Created by Omar Bermejo Osuna on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var cards: [CardItem] = []
    var body: some View {
        NavigationStack {
            List(cards) { card in
                NavigationLink(destination: CardDetalle(item: card)) {
                    CardView(item: card)
                }
            }
            .navigationTitle("Mis Cards")
            .onAppear { cards = loadCards() }
        }
    }
}

    

#Preview {
    ContentView()
}
