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
            Image(item.imageName)
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(20)
                .padding()
            Text(item.title)
                .font(.largeTitle)
                .bold()
            Text(item.description)
                .font(.title3)
                .foregroundColor(.secondary)
                
                .padding()
         
        }
        .padding()
        .navigationTitle("Detalle")
    }
}

