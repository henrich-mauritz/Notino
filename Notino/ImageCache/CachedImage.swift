//
//  CachedImage.swift
//  Notino
//
//  Created by Henrich Mauritz on 06/03/2022.
//

import SwiftUI

struct CachedImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(urlSuffix: String,
         @ViewBuilder placeholder: () -> Placeholder,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(urlSuffix: urlSuffix))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
            } else {
                placeholder
            }
        }
    }
}
