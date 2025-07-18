import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    var team: String = ""
    
    func addTeam(team: String) async throws {
        do {
            self.team = team.lowercased()
            UserDefaults.standard.set(self.team, forKey: "selectedTeam")
            try await db.collection(team).addDocument(data: ["name": self.team])
        }
        catch {
            UserDefaults.standard.set(team.lowercased(), forKey: "selectedTeam")
            self.team = team.lowercased()
        }
    }
    
    @MainActor
    func upload(_ images: [UIImage], item mission: Mission) async throws -> [URL] {
        var urls: [URL] = []
        
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert image to JPEG data")
                continue
            }
            
            let imageId = UUID().uuidString
            let storageRef = Storage.storage().reference().child("\(team)/\(mission.title)/\(imageId).jpg")
            
            do {
                if try await putData(imageData: imageData, storageRef: storageRef) {
                    if let urlString = try await download(imageString: imageId, from: "\(team)/\(mission.title)"){
                        if let url = URL(string: urlString) {
                            urls.append(url)
                        }
                        let timestamp = Timestamp(date: Date())
                        try await db.collection(team).document(imageId).setData(["id": mission.title,
                                                                                 "desc": mission.subtitle,
                                                                                 "url": urlString,
                                                                                 "timestamp": timestamp])
                    }
                }
            } catch {
                print("Error uploading image: \(error.localizedDescription)")
            }
        }
        
        return urls
    }
    
    @MainActor
    func putData(imageData: Data, storageRef: StorageReference) async throws -> Bool {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            _ = try await storageRef.putDataAsync(imageData)
            return true
        } catch {
            print("Error uploading imageData: \(error.localizedDescription)")
            return false
        }

    }
    
    @MainActor
    func download(imageString: String, from folder: String) async throws  -> String? {
        let storageRef = Storage.storage().reference().child("\(folder)/\(imageString).jpg")
        do {
            let downloadUrl = try await storageRef.downloadURL()
            print("Download URL: \(downloadUrl.absoluteString)")
            return downloadUrl.absoluteString
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor
    func fetchImages(completion: @escaping ([Mission]) -> Void) async {
        do {
            self.db.collection(team).getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to fetch images: \(error)")
                    completion([])
                    return
                }
                
                var missions: [Mission] = []
                
                for document in snapshot!.documents {
                    let data = document.data()
                    if  let title = data["id"] as? String,
                        let urlString = data["url"] as? String, let url = URL(string: urlString),
                        let subtitle = data["desc"] as? String {
                        missions.append(Mission(title: title, subtitle: subtitle, imageUrl: url))
                    }
                }
                completion(missions)
            }
        }
    }
    
    func fetchMap() async -> String {
        await withCheckedContinuation { continuation in
            self.db.collection("data").document("map").getDocument { document, error in
                if let error = error {
                    print("Failed to fetch map: \(error)")
                    continuation.resume(returning: "https://www.google.com/maps/d/u/2/edit?mid=1HDNBzc6_WrCfRP1fcPSiNAr7DYcIXmY&usp=sharing")
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()
                    if let urlString = data?["url"] as? String {
                        continuation.resume(returning: urlString)
                    } else {
                        continuation.resume(returning: "https://www.google.com/maps/d/u/2/edit?mid=1HDNBzc6_WrCfRP1fcPSiNAr7DYcIXmY&usp=sharing")
                    }
                } else {
                    continuation.resume(returning: "https://www.google.com/maps/d/u/2/edit?mid=1HDNBzc6_WrCfRP1fcPSiNAr7DYcIXmY&usp=sharing")
                }
            }
        }
    }
    
    func fetchMissions() async -> [String:String] {
        await withCheckedContinuation { continuation in
            self.db.collection("data").document("missions").getDocument { document, error in
                if let error = error {
                    print("Failed to fetch missions: \(error)")
                    continuation.resume(returning: [:])
                    return
                }
                
                if let challenges = document?.data() as? [String:String] {
                    continuation.resume(returning: challenges)
                } else {
                    print("No challenges found or wrong format.")
                    continuation.resume(returning: [:])
                }
            }
        }
    }
}
