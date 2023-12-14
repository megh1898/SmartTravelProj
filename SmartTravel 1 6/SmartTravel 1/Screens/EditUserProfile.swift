import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestore


struct InterestsListModel {
    var title: String
    var isSelected: Bool = false
}


struct EditUserProfile: View {
    
    @State private var isShowingPopup = false
    @State private var showImagePicker: Bool = false
    
    @State private var image: UIImage = UIImage(systemName: "person.circle")!
    @State private var showSheet = false
    
    @Binding var name: String
    @Binding var bio: String
    @Binding var age: String
    @Binding var interest: String
    @Binding var imageURL: String
    
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = false
    
    @State private var isPopoverPresented = false
    @State private var selectedOption: String?

    @State private var newInterestsList = [InterestsListModel]()
    
    var body: some View {
        VStack {
            profilePlaceholderView
                .onTapGesture {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
            
            TextField("Name", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Bio", text: $bio)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Date of Birth", text: $age)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    isDatePickerVisible.toggle()
                }
            
            HStack {
                Text("Interests")
                    .font(.body)
                    .padding(.leading, 20)
                Spacer()
            }
            
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(newInterestsList.indices, id: \.self) { interest in
                            if newInterestsList[interest].isSelected {
                                Text(newInterestsList[interest].title)
                                    .padding(4)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 16)
                }
                
                Button {
                    isPopoverPresented.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .frame(width: 30, height: 30)
                        .font(.title)
                }
                .padding(.trailing, 16)
            }
            
            Spacer()
            
            Button(action: {
                self.interest = self.newInterestsList.filter({
                    $0.isSelected
                }).map({
                    $0.title
                }).joined(separator: ",")
                uploadData()
            }) {
                Text("Update Profile")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            if isDatePickerVisible {
                DatePicker("age", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .padding()
                Button("Done") {
                    isDatePickerVisible = false
                    age = getFormattedDate()
                }
                .padding()
                .foregroundColor(.blue)
            }
        }
        .alert(isPresented: $isShowingPopup) {
            Alert(
                title: Text("Success"),
                message: Text("Profile updated successfully"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            selectedDate = dateFromString(age) ?? Date()
            
            let interests = self.interest.components(separatedBy: ",")
            
            for item in interests {
                if !item.isEmpty {
                    self.newInterestsList.append(InterestsListModel(title: item, isSelected: true))
                }
            }
            
            FirebaseManager.shared.getInterests { allInterests, err in
                if err == nil {

                    if self.newInterestsList.count == 0 {
                        
                        for item in allInterests ?? [] {
                            
                            self.newInterestsList.append(InterestsListModel(title: item, isSelected: false))
                        }
                    } else {
                        for item in allInterests ?? [] {
                            
                            if !self.newInterestsList.contains(where: { $0.title == item }) {
                                
                                self.newInterestsList.append(InterestsListModel(title: item, isSelected: false))
                            }
                        }
                    }
                }
            }
        }
        .popover(isPresented: $isPopoverPresented, arrowEdge: .top) {
            VStack {
                
                Button {
                    isPopoverPresented.toggle()
                } label: {
                    Text("Save")
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.body)
                }

                
                ForEach(newInterestsList.indices, id: \.self) { index in
                    Button(action: {
                        newInterestsList[index].isSelected.toggle()
                    }) {
                        HStack {
                            Text(newInterestsList[index].title)
                                .foregroundColor(newInterestsList[index].isSelected ? .blue : .primary)
                            Spacer()
                            if newInterestsList[index].isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding()
        }
    }
    
    func dateFromString(_ dateString: String, format: String = "MMM d, yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    private func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: selectedDate)
    }
    
    private func profileImageView() -> some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            let plaeholder = Image(systemName: "person.crop.circle.fill.badge.xmark")
            switch phase {
            case .empty:
                plaeholder
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
                
            case .success(let image):
                image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
                
            case .failure:
                plaeholder
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
            @unknown default:
                plaeholder
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
            }
        }
    }
    
    private var profilePlaceholderView: some View  {
        Image(uiImage: image)
            .resizable()
            .clipShape(Circle())
            .frame(width: 120, height: 120)
            .foregroundColor(.white)
            .scaledToFill()
            .background(Color.white)
            
    }
    
    func uploadData() {
        let storage = Storage.storage()
        
        let selectedImage = image
        
        guard !name.isEmpty else {
            print("Please enter a name.")
            return
        }
        
        // Convert UIImage to Data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data.")
            return
        }
        
        // Create a unique identifier for the image
        let imageID = UUID().uuidString
        
        // Firebase Storage Reference
        let storageRef = storage.reference().child("userImages").child("\(imageID).jpg")
        
        // Upload image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                // Image uploaded successfully, now save user profile data to Firestore
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        saveUserProfileToFirestore(imageURL: downloadURL, isShowingPopup: $isShowingPopup)
                    }
                }
            }
        }
    }
    
    func saveUserProfileToFirestore(imageURL: URL, isShowingPopup: Binding<Bool>) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("userProfile")
        
        // Get the document reference for the current user
        let userDocument = usersCollection.document(AppUtility.shared.userId!)
        
        // Check if the user profile document exists
        userDocument.getDocument { document, error in
            if let document = document, document.exists {
                // User profile exists, update the data
                userDocument.updateData([
                    "name": name,
                    "bio": bio,
                    "age": getFormattedDate(),
                    "interest": interest,
                    "profileImageURL": imageURL.absoluteString
                ]) { error in
                    if let error = error {
                        print("Error updating user profile: \(error.localizedDescription)")
                    } else {
                        print("User profile updated successfully in Firestore.")
                        isShowingPopup.wrappedValue = true
                        
                    }
                }
            } else {
                // User profile doesn't exist, create a new one
                let userData: [String: Any] = [
                    "name": name,
                    "bio": bio,
                    "age": age,
                    "interest": interest,
                    "profileImageURL": imageURL.absoluteString
                ]
                
                usersCollection.document(AppUtility.shared.userId!).setData(userData) { error in
                    if let error = error {
                        print("Error creating user profile: \(error.localizedDescription)")
                    } else {
                        print("User profile created successfully in Firestore.")
                        isShowingPopup.wrappedValue = true
                    }
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}
extension Color {
    static let brandColor = Color(red: 0.04, green: 0.15, blue: 0.33)
}
