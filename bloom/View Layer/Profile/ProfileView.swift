//
//  ProfileView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    let rowInsets = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    
    var body: some View {
        List {
            // Header section
            Section {
                ProfileDetailView(profile: viewModel.profile)
                    .listSectionSeparator(.hidden)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            
            // Link section
            Section {
                // TODO: Implement links
                ProfileViewListItem(
                    icon: "star",
                    title: "Leave a review",
                    subtitle: nil,
                    listItemStyle: .link,
                    action: {viewModel.printLn()}
                )
                ProfileViewListItem(
                    icon: "shippingbox",
                    title: "Suggest an improvment",
                    subtitle: nil,
                    listItemStyle: .link,
                    action: {}
                )
            }
            .listRowSeparatorTint(Theme.textPrimary.opacity(0.25))
            .listRowBackground(Theme.sectionBackground)
            .listRowInsets(rowInsets)
            
            // Settings Section
            Section {
                // TODO: Implement settings functions
//                ProfileViewListItem(
//                    icon: "tram",
//                    title: "Travel method",
//                    subtitle: "Set the default for getting directions",
//                    listItemStyle: .navigation,
//                    action: {}
//                )
//                
//                ProfileViewListItem(
//                    icon: "number",
//                    title: "Units of measure",
//                    subtitle: "Choose how we show you distance",
//                    listItemStyle: .navigation,
//                    action: {}
//                )
                
                ProfileViewListItem(
                    icon: "bell",
                    title: "Notifications",
                    subtitle: "Update your contact preferences",
                    listItemStyle: .navigation,
                    action: {}
                )
                
                ProfileViewListItem(
                    icon: "ant",
                    title: "Report a bug",
                    subtitle: "Let us know something went wrong",
                    listItemStyle: .navigation,
                    action: {}
                )
                
                ProfileViewListItem(
                    icon: "doc.text",
                    title: "Legal documents",
                    subtitle: "The boring text we need to share",
                    listItemStyle: .navigation,
                    action: {}
                )
            } header: {
                Text("Settings")
                    .font(.title2)
                    .textCase(.none)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                    .foregroundStyle(Theme.textSecondary)
            }
            .listRowBackground(Theme.sectionBackground)
            .listRowSeparatorTint(Theme.textPrimary.opacity(0.25))
            .listRowInsets(rowInsets)
            
            // Delete account
            Section {
                ProfileViewListItem(
                    icon: "trash",
                    title: "Delete account",
                    subtitle: "Had enough coffee? Say goodbye",
                    listItemStyle: .navigation,
                    isDestructive: true,
                    action: {}
                )
            }
            .listRowBackground(Theme.Destructive.Background.weak)
            .listRowInsets(rowInsets)
        }
        .scrollContentBackground(.hidden)
        .background(Theme.primaryBackground)
        .foregroundStyle(Theme.textPrimary)
    }
}

struct ProfileDetailView: View {
    
    let profile: User
    
    var body: some View {
        VStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.96, green: 0.91, blue: 0.85))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.brown)
                            )
            Text(profile.username)
                .font(.system(size: 32))
                .fontWeight(.bold)
            
            Text(profile.email)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProfileViewListItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let listItemStyle: ListItemStyle
    var isDestructive: Bool = false
    let action: () -> Void
    

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(isDestructive ? Theme.Destructive.Background.strong : Theme.fillBackground)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if subtitle != nil {
                    Text(subtitle ?? "")
                        .font(.caption)
                        .foregroundStyle(isDestructive ? Theme.Destructive.Text.secondary : Theme.textSecondary)
                }
            }
            Spacer()
            Button {
                action()
            } label: {
                switch listItemStyle {
                case .navigation:
                    Image(systemName: "chevron.right")
                case .link:
                    Image(systemName: "arrow.up.right")
                }
                
            }
        }
        .foregroundStyle(isDestructive ? Theme.Destructive.Text.primary : Theme.textPrimary)
    }
}

enum ListItemStyle {
    case navigation
    case link
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(profile: nil))
}
