import SwiftUI
import SDWebImageSwiftUI

struct MissionsView: View {
    @StateObject private var viewModel = MissionsViewModel()
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        VStack(alignment: .center) {
            if let title = viewModel.title {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            ScrollView {
                content
                    .padding(.top)
                    .padding(.horizontal, 16)
            }
            
        }
        .padding(.vertical, 64)
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
        .background(GradientBackgroundView())
    }
    
    var content: some View {
        VStack(alignment: .center) {
            if viewModel.missions.isEmpty {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height / 2)
            } else {
                ForEach(viewModel.missions) { mission in
                    MissionCardView(mission: mission,
                                    onTapAction: { viewModel.onImageTap(mission: mission) })
                    .padding(.vertical, 16)
                    .sheet(isPresented: $viewModel.showImagePicker, onDismiss: {
                        viewModel.upload(image: selectedImages)
                    }) {
                        ImagePicker(selectedImages: $selectedImages)
                    }
                    .sheet(isPresented: $viewModel.onImageTap, onDismiss: {
                        viewModel.selectedMission = nil
                    }) {
                        if let image = viewModel.selectedMission?.imageUrl {
                            VStack(alignment: .center, spacing: 0) {
                                VStack {
                                    WebImage(url: image)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MissionsView()
}
