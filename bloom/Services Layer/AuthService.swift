//
//  StateService.swift
//  bloom
//
//  Created by Mark Brown on 29/06/2025.
//

import Foundation

class AuthService: ObservableObject {
    
    @Published var authState: AuthState = .checking
    
    func getAuthState() async {
        
//        for await state in supabase.auth.authStateChanges {
//             if [.initialSession, .signedIn, .signedOut].contains(state.event) && state.session != nil {
//                 await MainActor.run {
//                     authState = .authenticated
//                 }
//             } else {
//                 await MainActor.run {
//                     authState = .unauthenticated
//                 }
//             }
//         }
        
        // MARK: Use to mock different auth states
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        await MainActor.run {
            authState = .authenticated
        }
    }
    
}

enum AuthState {
    
    case checking
    case authenticated
    case unauthenticated
    
}

