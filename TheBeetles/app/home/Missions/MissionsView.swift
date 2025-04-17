import SwiftUI
import SDWebImageSwiftUI

struct MissionsView: View {
    @StateObject private var viewModel = MissionsViewModel()
    @State private var selectedImages: [UIImage] = []
    @AppStorage("selectedTeam") var selectedTeam: String?
    
    var body: some View {
        ScrollView {
            missions
                .padding(.horizontal, 16)
        }
    }
    
    var missions: some View {
        VStack(alignment: .leading) {
            if let selectedTeam {
                Text(selectedTeam)
                    .bold()
                    .font(.custom("PlusJakartaSans-Bold", size: 24))
            }
            ForEach(viewModel.missions) { mission in
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        VStack(alignment: .leading) {
                            title(from: mission.title)
                            HStack {
                                subtitle(from: mission.subtitle)
                                Spacer()
//                                                                if mission.imageUrl == nil {
//                                                                    addAction(mission: mission)
//                                                                }
                            }
                        }
                        .padding()
                    }
                    if let url = mission.imageUrl {
                        image(imageUrl: url, mission: mission)
                    } else {
                        placeholderImage(mission: mission)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12).stroke(.appBlue, lineWidth: 1))
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
    
    private func image(imageUrl: URL, mission: Mission) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundStyle(.appBlue)
                .onTapGesture {
                    viewModel.onSubmitTap()
                    viewModel.selectedMission = mission
                }
            WebImage(url: imageUrl)
                .resizable()
                .indicator(.activity)
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                .scaledToFit()
                .padding(8)
                .opacity(0.8)
                .onTapGesture {
                    viewModel.onImageTap.toggle()
                    viewModel.selectedMission = mission
                }
        }
        
    }
    
    private func placeholderImage(mission: Mission) -> some View {
        ZStack {
            Rectangle()
                .fill(.appBlue.opacity(0.1))
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                .padding(8)
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundStyle(.appBlue)
        }
        .onTapGesture {
            viewModel.onSubmitTap()
            viewModel.selectedMission = mission
        }
    }
    
    private func addAction(mission: Mission) -> some View {
        Image(systemName: "plus.circle")
            .renderingMode(.template)
            .foregroundStyle(.appRed)
            .padding(.trailing, 4)
            .onTapGesture {
                viewModel.onSubmitTap()
                viewModel.selectedMission = mission
            }
    }
    
    private func title(from text: String) -> some View {
        Text(text)
            .font(.custom("PlusJakartaSans-Bold", size: 20))
    }
    
    private func subtitle(from text: String) -> some View {
        Text(text)
            .font(.custom("PlusJakartaSans-Light", size: 16))
    }
}

#Preview {
    MissionsView()
}
