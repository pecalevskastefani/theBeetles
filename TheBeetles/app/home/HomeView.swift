import SwiftUI
struct HomeView: View {
    @State var selectedIndex = 0
    @AppStorage("selectedTeam") var selectedTeam: String?
    
    init(selectedTeam: String) {
        self.selectedTeam = selectedTeam
    }
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            MapView()
                .clipped()
                .tabItem {
                    Label("Map", systemImage: "mappin.and.ellipse")
                }
                .tag(0)
            
            MissionsView()
                .clipped()
                .tabItem {
                    Label("Missions", systemImage: "square.and.pencil")
                }
                .tag(1)
        }
    }
}
