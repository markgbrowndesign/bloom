//
//  ProfileViewModel.swift
//  bloom
//
//  Created by Mark Brown on 24/05/2025.
//

import Foundation

class ProfileViewModel: ObservableObject {
 
    @Published var profile: User
    
    init(profile: User?) {
        
        guard let profile = profile else {
            self.profile = User(
                id: UUID(uuidString: "1234"),
                email: "coffeebrewer@example.com",
                username: "EspressoExplorer29",
                imageURL: "https://via.placeholder.com/150",
                updatedAt: "today"
            )
            return
        }
        self.profile = profile
    }
    
    func printLn() {
        print("blah blah")
    }
    
}
