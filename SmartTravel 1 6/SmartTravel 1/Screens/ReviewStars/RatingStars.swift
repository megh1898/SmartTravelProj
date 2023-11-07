//
//  RatingStars.swift
//  SmartTravel 1
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI
import StarRating

struct RatingStars: View {
    
    @State var customConfig = StarRatingConfiguration(numberOfStars: 5, minRating: 1, starVertices: 5, starWeight: 0.45)

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        StarRating(initialRating: 2.0, configuration: $customConfig) { newRating in
            print(newRating)
            customConfig.starVertices = Int(newRating)
        }
    }
}

#Preview {
    RatingStars()
}
