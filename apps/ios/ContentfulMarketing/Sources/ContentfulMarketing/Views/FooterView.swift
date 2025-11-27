import SwiftUI

struct FooterView: View {
    let footer: FooterData?
    let onNavigate: (String) -> Void
    
    var body: some View {
        if let footer = footer {
            VStack(alignment: .leading, spacing: 16) {
                // Menu Items
                if let menuItems = footer.menuItems, !menuItems.isEmpty {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(menuItems) { menuGroup in
                            FooterMenuColumn(
                                menuGroup: menuGroup,
                                onNavigate: onNavigate
                            )
                        }
                    }
                }
                
                // Social Links and Copyright
                HStack {
                    Text("COLORFULCOLLECTIVE")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if footer.twitterLink != nil {
                            Button(action: { /* Handle Twitter */ }) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.primary)
                            }
                        }
                        if footer.facebookLink != nil {
                            Button(action: { /* Handle Facebook */ }) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.primary)
                            }
                        }
                        if footer.linkedinLink != nil {
                            Button(action: { /* Handle LinkedIn */ }) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.primary)
                            }
                        }
                        if footer.instagramLink != nil {
                            Button(action: { /* Handle Instagram */ }) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                
                // Copyright
                Text("© Copyright \(Calendar.current.component(.year, from: Date()))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                // Legal Links
                if let legalLinks = footer.legalLinks, !legalLinks.isEmpty {
                    HStack(spacing: 16) {
                        ForEach(legalLinks) { legalLink in
                            Button(action: {
                                if let path = legalLink.path {
                                    let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
                                    onNavigate(cleanPath)
                                }
                            }) {
                                Text(legalLink.label ?? "")
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0xF4/255.0, green: 0xF4/255.0, blue: 0xF4/255.0))
        }
    }
}

struct FooterMenuColumn: View {
    let menuGroup: FooterMenuGroupData
    let onNavigate: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Group Name
            Text(menuGroup.groupName ?? "")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
            
            // Menu Items
            if let menuItems = menuGroup.menuItems {
                ForEach(menuItems) { menuItem in
                    Button(action: {
                        if let path = menuItem.path {
                            let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
                            onNavigate(cleanPath)
                        }
                    }) {
                        Text(menuItem.label ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

