import SwiftUI

struct NotificationListingView: View {
    
    @Binding var presentSideMenu: Bool
    @State var notifications = [NotificationData]()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button{
                        presentSideMenu.toggle()
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                }
                
                Text("Notification Listing")
                
                ForEach(notifications, id: \.id) { item in
                    NotificationCellView(notificationDescription: item.description)
                }
                Spacer()
            }
            .onAppear {
                FirebaseManager.shared.getNotifications(userID: AppUtility.shared.userId!) { notifications, error in
                    self.notifications = notifications ?? []
                }
            }
        .padding(.horizontal, 24)
        }
    }
    
}

#Preview {
    NotificationListingView(presentSideMenu: .constant(true))
}

struct NotificationCellView: View {
    
    var notificationDescription: String
        
    var body: some View {
            Text(notificationDescription)
                .multilineTextAlignment(.leading) // Horizontal alignment
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black.opacity(0.04))
                .cornerRadius(10)
        
        
    }
}
