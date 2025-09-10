//
//  CardMernu.swift
//  ClaseIOS
//
//  Created by Omar Bermejo Osuna on 09/09/25.
//


import SwiftUI


struct CardItem: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let description: String
}


let sampleJSON = """
[
  {
    "id": "1",
    "title": "Twitter",
    "subtitle": "Red social",
    "imageName": "twitter",
    "description": "Plataforma para compartir ideas rápidas, noticias y tendencias en tiempo real."
  },
  {
    "id": "2",
    "title": "Facebook",
    "subtitle": "Red social",
    "imageName": "facebook",
    "description": "Red social enfocada en conectar amigos, familiares y comunidades en línea."
  },
  {
    "id": "3",
    "title": "Reddit",
    "subtitle": "Red social",
    "imageName": "reddit",
    "description": "Foro global donde los usuarios comparten noticias, debates y comunidades temáticas."
  },
  {
    "id": "4",
    "title": "Instagram",
    "subtitle": "Red social",
    "imageName": "instagram",
    "description": "Aplicación centrada en fotos y videos, ideal para contenido visual y creativo."
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
        HStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    
        .frame(maxWidth: .infinity, alignment: Alignment.leading)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}



// Lista de Cards
struct CardsListView: View {
    @State private var cards: [CardItem] = loadCards()
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
    }
}


#Preview {
    CardsListView()
}

