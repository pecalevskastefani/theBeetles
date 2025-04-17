import SwiftUI
import SwiftData

class OnboardingViewModel: ObservableObject {
    @AppStorage("selectedTeam") var selectedTeam: String?
    @Published var team: String = ""
    @Published var alreadySelectedTeam: Bool = false
    
    init() {
        UserDefaults.standard.removeObject(forKey: "selectedTeam")
        team = selectedTeam ?? ""
        alreadySelectedTeam = !team.isEmpty
    }
}
struct OnboardingView: View {
    var teams = ["Team Crackheads", "Team Bananas", "Team Stefi", "Team Jimmy"]
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
        }
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
            TextField("Add your team's name", text: $viewModel.team)
                .multilineTextAlignment(.center)
                .overlay(Rectangle().frame(height: 2).padding(.top, 34).foregroundStyle(.appBlue.opacity(0.6)))
                .frame(width: UIScreen.main.bounds.size.width * 0.5)
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
                .font(.custom("PlusJakartaSans-LightItalic", size: 20))
                .multilineTextAlignment(.center)
            Text("'The Beetles Treasure Hunt'")
                .font(.custom("PlusJakartaSans-LightItalic", size: 20))
                .multilineTextAlignment(.center)
        }
    }
    
    private var selectTeamDropDown: some View {
        Menu(content: {
            ForEach(teams, id: \.self) { team in
                Button(action: {
                    viewModel.team = team
                }, label: {
                    Text(team)
                })
            }
        }, label:  { Text("\(viewModel.team) ") +
            Text(Image(systemName: "chevron.down"))
        })
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .font(.custom("PlusJakartaSans-Light", size: 16))
        .foregroundStyle(Color.black)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.appLightGray))
    }
    
    private var action: some View {
        NavigationLink(destination: HomeView(selectedTeam: viewModel.team)) {
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

#Preview {
    OnboardingView()
}
