//
//  CardDetalle.swift
//  ClaseIOS
//
//  Created by Omar Bermejo Osuna on 09/09/25.
//

import SwiftUI
struct CardDetalle: View {
    let item: CardItem
    
    var body: some View {
        VStack(spacing: 16) {
            Text(item.title)
                .font(.largeTitle)
                .bold()
            Text(item.subtitle)
                .font(.title3)
                .foregroundColor(.secondary)
         
        }
        .padding()
        .navigationTitle("Detalle")
    }
}
