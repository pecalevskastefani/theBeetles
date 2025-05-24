import SwiftUI
struct HomeView: View {
    @State var selectedIndex = 0
    @AppStorage("selectedTeam") var selectedTeam: String?
    
    init(selectedTeam: String) {
        self.selectedTeam = selectedTeam
    }
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            MissionsView()
                .tabItem {
                    Label("Missions", systemImage: "square.and.pencil")
                }
                .tag(0)
            MapView()
                .tabItem {
                    Label("Map", systemImage: "mappin.and.ellipse")
                }
                .tag(1)
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
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
