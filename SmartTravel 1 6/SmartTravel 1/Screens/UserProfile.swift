//
//  UserProfile.swift
//  SmartTravel 1
//
//  Created by Sam 77 on 2023-10-15.
//

import SwiftUI

struct UserProfile: View {
    var body: some View {
        VStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .background(Color(red: 0.04, green: 0.15, blue: 0.33))
                .padding(.top, 20)
            
            Text("Krupa Patel")
                .font(.title)
                .foregroundColor(Color(red: 0.04, green: 0.15, blue: 0.33))
                .padding(.top, 10)
            
            Text("krupa@example.com")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("User Information")
                    .font(.title)
                    .foregroundColor(Color(red: 0.04, green: 0.15, blue: 0.33))
                    .padding(.bottom, 10)
                
                UserInfoRow(title: "Location", value: "North York, Toronto")
                UserInfoRow(title: "Age", value: "23")
                UserInfoRow(title: "Interests", value: "Traveling, Photography")
                
                Text("About Me")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color(red: 0.04, green: 0.15, blue: 0.33))
                    .padding(EdgeInsets(top: 10.35, leading: 7.76, bottom: 10.35, trailing: 12.94))
                    .cornerRadius(5)
                
                Text("I love to explore new places and capture memories with my camera. Traveling is my passion.")
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
//        .navigationBarTitle("User Profile")
    }
}

struct UserInfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.blue)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(.vertical, 5)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
