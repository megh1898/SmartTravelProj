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
              let favourite = data["isFavourite"] as? Bool
              
              let id = document.documentID
              print("Location", location)
              let image = ImageData(id: id, imageURL: imageURL ?? "", title: title ?? "", location: location ?? "", rating: rating ?? "", filter: filter ?? "", isFavourite: favourite ?? false)
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

    func toggleImageOrderFavourite(imageData: ImageData, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let orderCollection = db.collection("images")

        // Construct a reference to the specific document using the imageOrder's ID
        let documentReference = orderCollection.document(imageData.id)

        // Toggle the isFavourite property
        let updatedIsFavourite = !imageData.isFavourite

        // Update the Firestore document with the new isFavourite value
        documentReference.updateData(["isFavourite": updatedIsFavourite]) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else {
                // Update the local imageOrder object
                var updatedImageOrder = imageData
                updatedImageOrder.isFavourite = updatedIsFavourite

                // Call the completion block with the updated imageOrder
                completion(nil)
            }
        }
    }
    
    
    func fetchFavouriteList(completion: @escaping ([ImageData]?, Error?) -> Void) {
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

                    guard let filter = data["filter"] as? String,
                        let imageURL = data["imageURL"] as? String,
                        let location = data["location"] as? String,
                        let rating = data["rating"] as? String,
                        let title = data["title"] as? String,
                        let isFavourite = data["isFavourite"] as? Bool
                    else {
                        continue
                    }

                    let id = document.documentID
                    print("Location", location)
                    let image = ImageData(id: id, imageURL: imageURL, title: title, location: location, rating: rating, filter: filter, isFavourite: isFavourite)

                    if isFavourite {
                        imageDataArray.append(image)
                    }
                }

                completion(imageDataArray, nil) // Call completion block once outside the loop
            }
        }
    }

    
    func addNotification(description: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let notificationCollection = db.collection("notification")

        let data: [String: Any] = ["description": description]

        notificationCollection.addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func fetchAllNotifications(completion: @escaping ([NotificationData]?, Error?) -> Void) {
        var notifications: [NotificationData] = []

        let db = Firestore.firestore()
        let notificationCollection = db.collection("notification")

        notificationCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    guard let description = data["description"] as? String else {
                        continue
                    }
                    
                    let id = document.documentID
                    let notification = NotificationData(id: id, description: description)
                    notifications.append(notification)
                }

                completion(notifications, nil)
            }
        }
    }
    
    func addReviewToFirestore(description: String, rating: String, location: String, title: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let reviewsCollection = db.collection("reviews")
        
        let reviewData: [String: Any] = [
            "description": description,
            "rating": rating,
            "title": title,
            "location": location
        ]
        
        reviewsCollection.addDocument(data: reviewData) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error) // Pass the error to the completion handler
            } else {
                completion(nil) // Indicate success with nil error
            }
        }
    }
    
    func fetchReviewsByTitleAndLocation(title: String, location: String, completion: @escaping ([ReviewData]?, Error?) -> Void) {
        var reviews: [ReviewData] = []

        let db = Firestore.firestore()
        let reviewsCollection = db.collection("reviews")

        reviewsCollection
            .whereField("title", isEqualTo: title)
            .whereField("location", isEqualTo: location)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()

                        guard let description = data["description"] as? String,
                              let rating = data["rating"] as? String else {
                            continue
                        }

                        let id = document.documentID
                        let review = ReviewData(id: id, location: location, rating: rating, description: description, title: title)
                        reviews.append(review)
                    }

                    completion(reviews, nil)
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

struct ReviewData: Identifiable {
    let id: String
    let location: String
    let rating: String
    let description: String
    let title: String
}


struct NotificationData: Identifiable {
    let id: String
    let description: String
}
