import SwiftUI
import SDWebImageSwiftUI

struct MissionsView: View {
    @StateObject private var viewModel = MissionsViewModel()
    @State private var selectedImages: [UIImage] = []
    @AppStorage("selectedTeam") var selectedTeam: String?
    
    var body: some View {
        VStack(alignment: .center) {
            if let selectedTeam {
                Text(selectedTeam)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            ScrollView {
                content
                    .padding(.top)
                    .padding(.bottom, 64)
                    .padding(.horizontal, 16)
            }
            
        }
        .padding(.top, 64)
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
        .background(GradientBackgroundView())
    }
    
    @ViewBuilder
    var rules: some View {
        if viewModel.showRulesSections {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .onTapGesture {
                        viewModel.showRulesSections.toggle()
                    }
                VStack(alignment: .leading, spacing: 4) {
                    Group {
                        Text("1. Bla bla exmaple hajnsfnnjfd")
                        Text("2. Bla bla eeefdfdmaple hajnsfnnjfd")
                        Text("3. Bla bla fdfdfdfdfdfd hajnsfnnjfd")
                        Text("4. Stefi ashdajsdas points")
                    }
                    .font(.custom("PlusJakartaSans-Light", size: 16))
                }
                Spacer()
            }
            .padding(.all, 16)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.appRed.opacity(0.5),
                                                                  lineWidth: 1))
        }
    }
    
    var content: some View {
        VStack(alignment: .center) {
         //   rules
            if viewModel.missions.isEmpty {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
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
    
    private func image(imageUrl: URL, mission: Mission) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundStyle(Color.appBlue)
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
                .fill(Color.appBlue.opacity(0.1))
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                .padding(8)
            Image(systemName: "plus")
                .renderingMode(.template)
                .foregroundStyle(Color.appBlue)
        }
        .onTapGesture {
            viewModel.onSubmitTap()
            viewModel.selectedMission = mission
        }
    }
    
    private func addAction(mission: Mission) -> some View {
        Image(systemName: "plus.circle")
            .renderingMode(.template)
            .foregroundStyle(Color.appRed)
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
            .font(.custom("PlusJakartaSans-Light", size: 12))
    }
}

#Preview {
    MissionsView()
}
