//
//  ContentView.swift
//  ClaseIOS
//
//  Created by Omar Bermejo Osuna on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var cards: [CardItem] =  loadCards()
        @StateObject private var store = ConfigStore()
        
        var filteredCards: [CardItem] {
            var result = cards
            
            // Filtrar si solo fotos
            if store.soloFotos {
                result = result.filter { !$0.imageName.isEmpty }
            }
            
            // Ordenar según preferencia
            switch store.orden {
            case .titulo:
                result = result.sorted { $0.title < $1.title }
            case .subtitulo:
                result = result.sorted { $0.subtitle < $1.subtitle }
            }
            
            // Limitar al número máximo
            return Array(result.prefix(store.maxItems))
        }
        
    var body: some View {
        NavigationStack {
            List(filteredCards) { card in
                NavigationLink(destination: CardDetalle(item: card)) {
                    CardView(item: card)
                }
                
            }
            .navigationTitle("Mis Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ConfigView(store: store)) {
                            Image(systemName: "gear")
                        }
                    }
            }
        }
        .preferredColorScheme(
                   store.apariencia == .automatic ? nil :
                   (store.apariencia == .light ? .light : .dark)
               )
    }
    
}

    

#Preview {
    ContentView()
}
