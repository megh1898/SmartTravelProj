import SwiftUI


struct OrderListingView: View {
    
    @Binding var presentSideMenu: Bool
    @State var orders = [OrderData]()
    @State private var showAlert = false
    
    var body: some View {
//        ScrollView {
            VStack{
                HStack{
                    Button{
                        presentSideMenu.toggle()
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                
                Text("My Itinerary")
                
                List {
                    ForEach(orders, id: \.id) { item in
                        OrderListingCellView(orderData: item)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
                
//                Spacer()
            }
            .onAppear {
                FirebaseManager.shared.getAllOrders { orderData, error in
                    self.orders = orderData ?? []
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Payment refund has been completed and trip is cancelled"),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
    private func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        FirebaseManager.shared.deleteOrder(userID: AppUtility.shared.userId!,
                                           orderId:  orders[index].id) { err in
            if err == nil {
                print("deleted")
                let newBalance = (AppUtility.shared.totalBalance ?? 0) + orders[index].price
                FirebaseManager.shared.updateBalance(newBalance: newBalance) { isSuccess, err in
                    if isSuccess {
                        
                        AppUtility.shared.totalBalance = newBalance
                        print("Payment Credited")
                       
                        FirebaseManager.shared.addNotification(userID: AppUtility.shared.userId!,
                                                               notification: "Refund of $\(orders[index].price) is completed for trip \(orders[index].title), \(orders[index].location)"){ error in
                            self.orders.remove(at: index)
                            self.showAlert.toggle()
                            if error == nil {
                                print("Notification added")
                            }
                        }
                    } else {
                        print(err?.localizedDescription ?? "")
                    }
                }
            }
        }
        
    }
    
}
#Preview {
    OrderListingView(presentSideMenu: .constant(true))
}

struct OrderListingCellView: View {
    
    var orderData = OrderData(id: "", filter: "", location: "", rating: "", title: "", price: 0, date: "")
    
    var body: some View {
        VStack {
            HStack {
                Text("Title:")
                Spacer()
                Text(orderData.title)
                    .font(.system(size: 18,weight: .semibold))
            }
            HStack {
                Text("Location:")
                Spacer()
                Text(orderData.location)
                    .font(.system(size: 18,weight: .semibold))
            }
            HStack {
                Text("Amount Paid")
                Spacer()
                Text("$\(orderData.price)")
                    .font(.system(size: 18,weight: .semibold))
            }
            HStack {
                Text("Date Scheduled")
                Spacer()
                Text(orderData.date)
                    .font(.system(size: 18,weight: .semibold))
            }
        }
        .padding()
        .background(Color.black.opacity(0.04))
        .cornerRadius(10)
    }
}
