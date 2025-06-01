//
//  ProfileViewModel.swift
//  bloom
//
//  Created by Mark Brown on 24/05/2025.
//

import Foundation
import Combine
import Supabase

class ProfileViewModel: ObservableObject {
 
    @Published var profile: Profile?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let user = User()
    private var cancellable = Set<AnyCancellable>()
    
    func loadUserProfile(forceRefresh: Bool = false) {
        
        guard let userId = supabase.auth.currentSession?.user.id else { return }
        
        user.$profile
            .compactMap { $0[userId] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingState in
                switch loadingState {
                case .idle:
                    self?.isLoading = false
                case .loading:
                    self?.isLoading = true
                    self?.error = nil
                case .loaded(let profile):
                    self?.isLoading = false
                    self?.profile = profile
                case .failed(let error):
                    self?.isLoading = false
                    self?.error = error
                }
            }
            .store(in: &cancellable)
        Task {
            await user.loadUserProfile(userId: userId, forceRefresh: forceRefresh)
        }
    }
    
    func refreshProfile() {
        self.loadUserProfile(forceRefresh: true)
    }
    
    func updateUserProfile(property: UserProfileProperty, value: Any) {
        
    }
    
    func logout() {
        
    }
    
}
