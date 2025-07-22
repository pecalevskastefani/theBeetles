import SwiftUI
import SDWebImageSwiftUI

struct MissionCardView: View {
    let mission: Mission
    let onImageTapAction:  () -> Void
    let onAddNewImageAction: () -> Void
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(mission.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            Text(mission.subtitle)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.7))
            HStack {
                if mission.isUploading {
                    ProgressView()
                        .frame(width: 30)
                } else if mission.imageUrl != nil {
                    Button(action: onImageTapAction) {
                        Image(systemName: "photo")
                            .foregroundColor(Color.appBlue)
                            .font(.system(size: 28))
                    }
                }
                Spacer()

                Button(action: onAddNewImageAction) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.appRed)
                        .font(.system(size: 28))
                }
            }
        }
        .clipped()
        .padding()
        .background(Color.appGray)
        .cornerRadius(20)
        .shadow(radius: 5)
        .onTapGesture {
            if mission.imageUrl != nil {
                onImageTapAction()
            }
        }
    }
    
    private var shape: some View {
        Rectangle().fill(Color.white).cornerRadius(30)
    }
    
    private func image(url: URL) -> some View {
        WebImage(url: url)
            .resizable()
            .cornerRadius(12)
            .clipShape(Rectangle())
            .frame(width: 80, height: 80)
            .scaledToFill()
            .opacity(0.8)
    }
    
    private var uploadingView: some View {
        Rectangle()
            .cornerRadius(12)
            .overlay {
                ProgressView()
                    .frame(width: 30)
            }
    }
}
