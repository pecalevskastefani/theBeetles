import SwiftUI
import SwiftData

class OnboardingViewModel: ObservableObject {
    @AppStorage("selectedTeam") var selectedTeam: String?
    @Published var team: String = "Team: "
    @Published var alreadySelectedTeam: Bool = false
    
    init() {
        UserDefaults.standard.removeObject(forKey: "selectedTeam")
        team = selectedTeam ?? ""
        alreadySelectedTeam = !team.isEmpty
    }
}
struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    
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
        VStack(alignment: .center, spacing: 24) {
            logo
            info
            addTeamInputField
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 36)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .frame(width: UIScreen.main.bounds.size.width)
    }
    
    @ViewBuilder
    private var addTeamInputField: some View {
        if viewModel.alreadySelectedTeam {
            VStack(spacing: 4) {
                Text("Your team:")
                    .font(.custom("PlusJakartaSans-Light", size: 20))
                    .multilineTextAlignment(.center)
                Text(viewModel.team)
                    .font(.custom("PlusJakartaSans-Bold", size: 20))
            }
        } else {
            ZStack {
                if viewModel.team.isEmpty {
                    Text("Add your team's name")
                        .foregroundColor(.white.opacity(0.8))
                }
                TextField("Add your team's name", text: $viewModel.team)
                    .multilineTextAlignment(.center)
                    .overlay(Rectangle().frame(height: 2).padding(.top, 34).foregroundStyle(Color.appBlue.opacity(0.8)))
                    .frame(width: UIScreen.main.bounds.size.width * 0.5)
                
            }
        }
    }
    
    
    private var logo: some View {
        Image(.theBeetlesLogo)
            .resizable()
            .frame(width: UIScreen.main.bounds.size.width * 0.6,
                   height: UIScreen.main.bounds.size.height / 4)
            .accessibilityHidden(true)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(spacing: 4) {
            Text("Welcome to")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Text("'The Beetles Treasure Hunt'")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var action: some View {
        NavigationLink(destination: HomeView(selectedTeam: viewModel.team)) {
            if !viewModel.team.isEmpty {
                Text("Get started")
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 6)
                        .fill(Color.appRed)
                        .frame(width: UIScreen.main.bounds.size.width * 0.4)
                    )
                    .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
