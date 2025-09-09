//
//  CardMernu.swift
//  ClaseIOS
//
//  Created by Omar Bermejo Osuna on 09/09/25.
//


import SwiftUI

// Modelo simple
struct CardItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
}

// Ejemplo de JSON
let sampleJSON = """
[
  {
    "id": "9F1B8F1A-9C3E-4C29-A4D0-1B7C6E6C3A6A",
    "title": "Café artesanal",
    "subtitle": "Tostado medio"
  },
  {
    "id": "2E4D7A10-3B6C-41E9-BE18-4E7C8C2B9D20",
    "title": "Libro SwiftUI",
    "subtitle": "UI modernas"
  }
]
"""

// Función para cargar JSON
func loadCards() -> [CardItem] {
    let data = Data(sampleJSON.utf8)
    let decoder = JSONDecoder()
    return (try? decoder.decode([CardItem].self, from: data)) ?? []
}

// Vista de Card
struct CardView: View {
    let item: CardItem
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
               
               
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
           
          
        }
    }
}

// Lista de Cards
struct CardsListView: View {
    @State private var cards: [CardItem] = []

    var body: some View {
        List(cards) { card in
            CardView(item: card)
        }
        .onAppear { cards = loadCards() }
    }
}

#Preview {
    CardsListView()
}

