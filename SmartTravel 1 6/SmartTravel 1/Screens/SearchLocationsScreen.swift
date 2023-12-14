import SwiftUI
import MapKit

struct SearchLocationsScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ContentViewModel()
    @Binding var location: CLLocation
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter City", text: $viewModel.cityText)
            Divider()
//            TextField("Enter Point of interest name", text: $viewModel.poiText)
            Text("Results")
                .font(.title)
            List(viewModel.viewData) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text(item.subtitle)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    location = item.location
                    dismiss()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .ignoresSafeArea(edges: .bottom)
    }
}
