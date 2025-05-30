//
//  AppView.swift
//  bloom
//
//  Created by Mark Brown on 11/05/2025.
//

import SwiftUI

struct AppView: View {
    @State var isAuthenticated = false
    var cafe: CoffeeShop?
      var body: some View {
        Group {
          if isAuthenticated {
              ContentView()
          } else {
            AuthView()
          }
        }
        .task {
          for await state in supabase.auth.authStateChanges {
            if [.initialSession, .signedIn, .signedOut].contains(state.event) {
              isAuthenticated = state.session != nil
            }
          }
        }
      }
}
