import SwiftUI

struct MobileMenuView: View {
    @Binding var isOpen: Bool
    let menuGroups: [MenuGroupData]?
    let onDismiss: () -> Void
    let onNavigate: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                // Overlay background - only visible when open
                Color.black.opacity(isOpen ? 0.3 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if isOpen {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isOpen = false
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isOpen)
                
                // Drawer - always rendered but offset when closed
                HStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                if let menuGroups = menuGroups {
                                    ForEach(Array(menuGroups.enumerated()), id: \.element.id) { index, menuGroup in
                                        if index > 0 {
                                            Spacer()
                                                .frame(height: 16)
                                        }
                                        
                                        // If menuGroup has a link, make it clickable (like Next.js)
                                        if let link = menuGroup.link {
                                            MenuItemText(
                                                text: menuGroup.groupName ?? "",
                                                onClick: {
                                                    if let path = link.path {
                                                        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
                                                        onNavigate(cleanPath)
                                                    }
                                                    withAnimation {
                                                        isOpen = false
                                                    }
                                                    onDismiss()
                                                }
                                            )
                                        } else if let menuItems = menuGroup.menuItems, !menuItems.isEmpty {
                                            // If has children but no link, show as header with submenu
                                            MenuItemText(
                                                text: menuGroup.groupName ?? "",
                                                onClick: {},
                                                isHeader: true
                                            )
                                            
                                            // Menu items as submenu (with left border)
                                            ForEach(menuItems) { menuItem in
                                                MenuItemText(
                                                    text: menuItem.label ?? "",
                                                    onClick: {
                                                        if let path = menuItem.path {
                                                            let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
                                                            onNavigate(cleanPath)
                                                        } else if let externalLink = menuItem.externalLink {
                                                            // Handle external link if needed
                                                        }
                                                        withAnimation {
                                                            isOpen = false
                                                        }
                                                        onDismiss()
                                                    },
                                                    isSubmenu: true
                                                )
                                            }
                                        } else {
                                            // Fallback: just show group name (non-clickable)
                                            MenuItemText(
                                                text: menuGroup.groupName ?? "",
                                                onClick: {},
                                                isHeader: true
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                        }
                    }
                    .frame(width: geometry.size.width * 0.33) // Match Android - 1/3 of screen width
                    .background(Color.white)
                    .offset(x: isOpen ? 0 : geometry.size.width * 0.33)
                    .animation(.easeInOut(duration: 0.3), value: isOpen)
                }
            }
            .allowsHitTesting(isOpen) // Only allow interactions when open
        }
    }
}

struct MenuItemText: View {
    let text: String
    let onClick: () -> Void
    var isHeader: Bool = false
    var isSubmenu: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Left border for submenu items
            if isSubmenu {
                Spacer()
                    .frame(width: 16)
                
                Rectangle()
                    .fill(Color(red: 0xEE/255.0, green: 0xEE/255.0, blue: 0xEE/255.0))
                    .frame(width: 1, height: 20)
                
                Spacer()
                    .frame(width: 16)
            }
            
            Text(text)
                .font(.system(size: 21, weight: .regular))
                .foregroundColor(.primary)
                .lineSpacing(21 * 0.8) // line height 1.8
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, isSubmenu ? 8 : 12)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isHeader {
                onClick()
            }
        }
    }
}

