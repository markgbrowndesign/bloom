//
//  ImageView.swift
//  bloom
//
//  Created by Mark Brown on 27/02/2026.
//

import Foundation
import SwiftUI

struct CachedImageView: View {
    
    let shopID: UUID
    let imageType: ImageServiceImageType
    let fallbackAsset: String
    var contentMode: ContentMode = .fill
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
                
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                Rectangle()
                    .fill(Theme.sectionBackground)
                    .overlay(ProgressView())
            } else {
                Image(fallbackAsset)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            }
        }
        .task(id: shopID) {
            isLoading = true
            image = await ImageService.shared.loadImage(for: shopID, imageType: imageType)
            isLoading = false
        }
    }
}
