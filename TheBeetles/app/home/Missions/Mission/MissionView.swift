import SwiftUI
import SDWebImageSwiftUI

struct MissionCardView: View {
    let mission: Mission
    let onTapAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            CustomCardShape()
                .fill(Color.appBlue.opacity(0.6))
                .frame(height: 150)
                .overlay(
                    VStack(alignment: .leading, spacing: 8) {
                        Text(mission.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        Text(mission.subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 30),
                    alignment: .leading
                )

            Button(action: onTapAction) {
                ZStack {
                    if let imageUrl = mission.imageUrl
                    {
                        WebImage(url: imageUrl)
                            .resizable()
                            .indicator(.activity)
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                            .scaledToFit()
                            .opacity(0.8)
                            .onTapGesture {
                                onTapAction()
                            }
                    } else {
                        Circle()
                            .fill(Color.appRed)
                            .frame(width: 60, height: 60)
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .offset(x: -10, y: -10)
        }
        .padding(.horizontal)
    }
}
