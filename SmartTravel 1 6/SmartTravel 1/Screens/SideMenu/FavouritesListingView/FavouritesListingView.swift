//
//  FavoriteListingView.swift
//  SideMenuView
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI


struct FavoriteListingView: View {
    
    @Binding var presentSideMenu: Bool
    @State var imageData = [ImageData]()

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
            
            Text("Favourites Listing View")
            
            ForEach(imageData, id: \.id) { item in
                let orderData = OrderData(id: item.id, filter: item.filter, location: item.location, rating: item.rating, title: item.title)
                OrderListingCellView(orderData: orderData)
            }
            
            
            Spacer()
        }
        .onAppear {
            FirebaseManager.shared.fetchFavouriteList { imagesData, error in
                self.imageData = imagesData ?? []
            }
        }
        .padding(.horizontal, 24)
    }
    
}
