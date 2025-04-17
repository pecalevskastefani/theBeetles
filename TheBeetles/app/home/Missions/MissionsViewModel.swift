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
    @Published var missions: [Mission] = [Mission(title: "Mission 1 title", subtitle: "Mission 1 subtitle"),
                               Mission(title: "Mission 2 title", subtitle: "Mission 2 subtitle"),
                               Mission(title: "Mission 3 title", subtitle: "Mission 3 subtitle")]
    @Published var showImagePicker: Bool = false
    @Published var onImageTap: Bool = false
    @AppStorage("selectedTeam") var team = ""
    var selectedMission: Mission? = nil
    
    init() {
        fetchImages()
    }
    
    func onSubmitTap()  {
        showImagePicker.toggle()
    }
    
    func fetchImages() {
        Task { @MainActor in
            do {
                await FirebaseManager.shared.fetchImages(team: team) { missions in
                    guard !missions.isEmpty else { return }
                    self.updateMissions(fetchedMissions: missions)
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
    
    func updateMissions(fetchedMissions: [Mission]) {
        for (index, originalMission) in missions.enumerated() {
            if let fetchedMission = fetchedMissions.first(where: { $0.title == originalMission.title }) {
                missions[index].imageUrl = fetchedMission.imageUrl
            }
        }
    }
}
