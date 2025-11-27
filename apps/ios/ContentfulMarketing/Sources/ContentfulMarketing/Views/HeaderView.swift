import SwiftUI

struct HeaderView: View {
    let onMenuClick: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Coin")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: onMenuClick) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(Color(.systemBackground))
    }
}

