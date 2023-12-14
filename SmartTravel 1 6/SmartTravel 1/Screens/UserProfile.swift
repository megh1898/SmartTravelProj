import SwiftUI
import Firebase
import FirebaseFirestore


struct UserProfile: View {
    @State private var editProfile = false
    @State private var imageURL = ""
    @State private var name = ""
    @State private var bio = ""
    @State private var age = ""
    @State private var interest = ""
    @State private var balance = 0
    @State private var image = UIImage()
    
    var body: some View {
        
        NavigationLink(destination: EditUserProfile(name: $name, bio: $bio, age: $age, interest: $interest, imageURL: $imageURL), isActive: $editProfile) {
            EmptyView()
        }
        .isDetailLink(false)
        
        
        ScrollView {
            VStack {
                profileImage
                
                Text(name)
                    .font(.title)
                    .foregroundColor(.brandColor)
                    .padding(.top, 10)
                
                Text(AppUtility.shared.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                
                Divider().padding(20)
                
                userInformation
                
                Spacer()
            }
            .toolbar(.visible, for: .navigationBar)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        editProfile.toggle()
                    }
                }
            }
            .onAppear {
                loadUserProfile()
            }
        }
    }
    
    private var profileImage: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                Image(systemName: "person.crop.circle.fill.badge.xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
                
            case .success(let image):
                image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
                
            case .failure:
                Image(systemName: "person.crop.circle.fill.badge.xmark")
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
                
            @unknown default:
                Image(systemName: "person.crop.circle.fill.badge.xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)
            }
        }
    }
    
    
    private var userInformation: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "User Information")
            
            UserInfoRow(title: "Location", value: "\(AppUtility.shared.city ?? "")")
            UserInfoRow(title: "Date of Birth", value: age)
            UserInfoRow(title: "Interests", value: interest)
            UserInfoRow(title: "Wallet Balance", value: "$\(balance)")
            
            Divider()
            
            SectionHeader(title: "About Me")
            
            Text(bio)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
    }
    
    private func loadUserProfile() {
        FirebaseManager.shared.getUserProfile(withId: AppUtility.shared.userId!) { data in
            name = data?.name ?? ""
            age = data?.age ?? ""
            bio = data?.bio ?? ""
            interest = data?.interest ?? ""
            imageURL = data?.profileImageURL ?? ""
            balance = data?.balance ?? 0
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .foregroundColor(.brandColor)
            .padding(.bottom, 10)
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
