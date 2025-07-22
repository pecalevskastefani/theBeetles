import SwiftUI
import SwiftData

class OnboardingViewModel: ObservableObject {
    @AppStorage("selectedTeam") var selectedTeam: String?
    @Published var team: String = ""
    var shouldShowPlaceholder: Bool {
        team.isEmpty
    }
    
    func addTeam() {
        Task { @MainActor in
            try await FirebaseManager.shared.addTeam(team: team)
        }
    }
    
    init() {
        UserDefaults.standard.removeObject(forKey: "selectedTeam")
        team = selectedTeam ?? ""
    }
}
struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    content
                }
                Spacer()
                action
            }
            .background(GradientBackgroundView())
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 0) {
            info
            addTeamInputField
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .frame(width: UIScreen.main.bounds.size.width)
    }
    
    @ViewBuilder
    private var addTeamInputField: some View {
        ZStack {
            TextField("Add your team name", text: $viewModel.team)
                .padding()
                .frame(width: UIScreen.main.bounds.size.width * 0.6)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appGray.opacity(0.5), lineWidth: 2)
                )
                .multilineTextAlignment(.center)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
    
    
    private var logo: some View {
        Image(.transparentLogo)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.appGray.opacity(0.9))
            .frame(width: UIScreen.main.bounds.size.width * 0.7,
                   height: 250)
            .accessibilityHidden(true)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(spacing: 0) {
            logo
            Text("Welcome to")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.appGray.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.top, -12)
            Text("The Beetles Treasure Hunt")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.appGray.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
        }
    }
    
    private var action: some View {
        NavigationLink(destination: HomeView()) {
            if !viewModel.team.isEmpty {
                Text("Get started")
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
                    .padding(.vertical, 10)
                    .foregroundStyle(Color.appGray.opacity(0.9))
                    .background(RoundedRectangle(cornerRadius: 6)
                        .fill(Color.appRed)
                        .frame(width: UIScreen.main.bounds.size.width * 0.4)
                    )
                    .padding(.bottom, 24)
            }
        }.simultaneousGesture(TapGesture().onEnded(viewModel.addTeam))
    }
}

#Preview {
    OnboardingView()
}
