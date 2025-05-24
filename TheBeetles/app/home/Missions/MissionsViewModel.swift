import Combine
import Foundation
import SwiftUI

class Mission: Identifiable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var imageUrl: URL?
    
    init(title: String, subtitle: String, imageUrl: URL? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
    
    func setUrl(url: String) {
        imageUrl = URL(string: url)
    }
}

class MissionsViewModel: ObservableObject {
    @Published var missions: [Mission] = []
    @Published var showImagePicker: Bool = false
    @Published var showRulesSections: Bool = true
    @Published var onImageTap: Bool = false
    @AppStorage("selectedTeam") var team = ""
    var selectedMission: Mission? = nil
    
    init() {
        fetchMissions()
    }
    
    func onSubmitTap()  {
        showImagePicker.toggle()
    }
    
    func fetchMissions() {
        Task { @MainActor in
            do {
                let result = await FirebaseManager.shared.fetchMissions()
                let items = result.compactMap { Mission(title: $0.key, subtitle: $0.value)}
                await FirebaseManager.shared.fetchImages(team: team) { missions in
                    guard !missions.isEmpty else {
                        self.missions = items
                        return
                    }
                    self.updateMissions(fetchedMissions: missions, missions: items)
                }
            }
        }
    }
    
    func upload(image: [UIImage]) {
        Task { @MainActor in
            do {
                guard let selectedMission, !image.isEmpty else { return }
                let url = try await FirebaseManager.shared.upload(image, item: selectedMission, team: team).first
                selectedMission.imageUrl = url
                updateAfterUpload(mission: selectedMission)
                self.selectedMission = nil
            }
        }
    }
    
    func updateAfterUpload(mission: Mission) {
        var updatedData: [Mission] = []
        for m in missions {
            if m.id == mission.id {
                let updatedMission = m
                updatedMission.imageUrl = mission.imageUrl
                updatedData.append(updatedMission)
            } else {
                updatedData.append(m)
            }
        }
        self.missions = updatedData
    }
    
    func updateMissions(fetchedMissions: [Mission], missions: [Mission]) {
        for (index, originalMission) in missions.enumerated() {
            if let fetchedMission = fetchedMissions.first(where: { $0.title == originalMission.title }) {
                missions[index].imageUrl = fetchedMission.imageUrl
            }
        }
        self.missions = missions
    }
    
    func onImageTap(mission: Mission) {
        if mission.imageUrl != nil {
            onImageTap.toggle()
            selectedMission = mission
        } else {
            onSubmitTap()
            selectedMission = mission
        }
    }
}
