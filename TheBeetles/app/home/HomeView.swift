import SwiftUI
struct HomeView: View {
    @State var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "mappin.and.ellipse")
                }
                .tag(0)
            MissionsView()
                .tabItem {
                    Label("Missions", systemImage: "square.and.pencil")
                }
                .tag(1)
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color.appGray)
        }
        .tint(Color.appCustomRed)
    }
}

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.appRed, Color.appBlue, Color.white]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(0.7)
        .ignoresSafeArea(.all)
    }
}
