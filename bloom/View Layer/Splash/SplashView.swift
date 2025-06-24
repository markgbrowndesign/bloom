//
//  SplashView.swift
//  bloom
//
//  Created by Mark Brown on 24/06/2025.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var state: StateService
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        Text("Loading")
            .task {
                await viewModel.intitalise()
            }
    }
}

#Preview {
    SplashView()
}
