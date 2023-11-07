//
//  OrderListingView.swift
//  SideMenuView
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI


struct OrderListingView: View {
    
    @Binding var presentSideMenu: Bool
    @State var orders = [OrderData]()
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            
            Text("Order Listing View")
            
            ForEach(orders, id: \.id) { item in
                OrderListingCellView(orderData: item)
            }
            
            
            Spacer()
        }
        .onAppear {
            FirebaseManager.shared.getAllOrders { orderData, error in
                self.orders = orderData ?? []
            }
        }
        .padding(.horizontal, 24)
    }
    
}
#Preview {
    OrderListingView(presentSideMenu: .constant(true))
}

struct OrderListingCellView: View {
    
    var orderData = OrderData(id: "", filter: "", location: "", rating: "", title: "")
    
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
                Text("Rating:")
                Spacer()
                Text(orderData.rating)
                    .font(.system(size: 18,weight: .semibold))
            }
        }
        .padding()
        .background(Color.black.opacity(0.04))
        .cornerRadius(10)
    }
}
