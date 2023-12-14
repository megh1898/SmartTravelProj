import SwiftUI



struct HomeVieww: View {
    
    @Binding var presentSideMenu: Bool
    
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
            
            Spacer()
            HomeScreen()
        }
        .padding(.horizontal, 15)
    }
    
}


#Preview {
    HomeVieww(presentSideMenu: .constant(true))
}

