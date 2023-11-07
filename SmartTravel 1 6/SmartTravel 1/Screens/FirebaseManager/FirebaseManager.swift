//
//  FirebaseManager.swift
//  SmartTravel 1
//
//  Created by Invotyx Mac on 07/11/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class FirebaseManager {
    
    static var shared = FirebaseManager()
    let db = Firestore.firestore()
    
    
    func fetchImageData(completion: @escaping ([ImageData]?, Error?) -> Void) {
      var imageDataArray: [ImageData] = []

      let db = Firestore.firestore()
      let imagesCollection = db.collection("images")

      imagesCollection.getDocuments { snapshot, error in

        
    if
     
    let error = error {
          completion(nil, error)
          return
        }

        if
     
    let snapshot = snapshot {
          for document in snapshot.documents {
            let data = document.data()

              let filter = data["filter"] as? String
              let imageURL = data["imageURL"] as? String
              let location = data["location"] as? String
              let rating = data["rating"] as? String
              let title = data["title"] as? String
              let id = document.documentID
              print("Location", location)
              let image = ImageData(id: id, imageURL: imageURL ?? "", title: title ?? "", location: location ?? "", rating: rating ?? "", filter: filter ?? "")
              imageDataArray.append(image)
            
          }

          completion(imageDataArray, nil) // Call completion block once outside the loop
        }
      }
    }
    
    
    func addOrder(filter: String, location: String, rating: String, title: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let orderCollection = db.collection("order")

        let data: [String: Any] = [
            "filter": filter,
            "location": location,
            "rating": rating,
            "title": title
        ]

        orderCollection.addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func getAllOrders(completion: @escaping ([OrderData]?, Error?) -> Void) {
        var orders: [OrderData] = []

        let db = Firestore.firestore()
        let orderCollection = db.collection("order")

        orderCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let filter = data["filter"] as? String
                    let location = data["location"] as? String
                    let rating = data["rating"] as? String
                    let title = data["title"] as? String
                    let id = document.documentID

                    let order = OrderData(id: id, filter: filter ?? "", location: location ?? "", rating: rating ?? "", title: title ?? "")
                    orders.append(order)
                }

                completion(orders, nil)
            }
        }
    }


}

struct OrderData: Identifiable {
    let id: String
    let filter: String
    let location: String
    let rating: String
    let title: String
}
