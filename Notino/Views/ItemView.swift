//
//  ItemView.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @ObservedObject var model: ItemViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Button(action: {
                    model.toggleFavorited()
                }) {
                    model.favorited ? Image("heartFull") : Image("heartEmpty")
                }
            }
            CachedImage(
                urlSuffix: model.item.imageUrl!,
                placeholder: {
                    Image("placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                },
                image: {
                    Image(uiImage: $0)
                }
            )
            
            Text(model.brandName)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Text(model.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(model.annotation)
                .font(.caption)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 0) {
                ForEach(model.score) { image in
                    image.image
                }
            }
            
            Text(model.price)
                .font(.body)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Button("DO KOŠÍKU") {
                NSLog("Button tapped")
            }
            .font(.footnote)
            .buttonStyle(.plain)
            .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
            .border(Color.primary)
            
            Spacer()
        }
    }
}
    

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
