//
//  SplashViewModel.swift
//  bloom
//
//  Created by Mark Brown on 24/06/2025.
//

import Foundation

class SplashViewModel: ObservableObject {
    
    private var launchService = LaunchService()
    
    func intitalise() async {
        
        await launchService.initialize()
        
        print("can now show app")
        
    }
    
    
}
