import CoreData

class PersistenceController: ObservableObject {
  static let shared = PersistenceController()
  let container: NSPersistentContainer
  @Published var errorMessage: String?
  @Published var showAlert: Bool = false
  
  init() {
    container = NSPersistentContainer(name: "MatchMate")
    container.loadPersistentStores { _, error in
      if let error = error {
        self.errorMessage = "Core Data failed to load: \(error.localizedDescription)"
        self.showAlert = true
      }
    }
  }
  
  func fetchProfiles() -> [UserProfile]? {
    let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
    do {
      let results = try container.viewContext.fetch(request)
      return results.map {
        UserProfile(
          id: $0.id ?? UUID(),
          name: $0.name ?? "",
          age: Int($0.age),
          location: $0.location ?? "",
          imageUrl: $0.imageURL ?? "",
          status: MatchStatus(rawValue: $0.status ?? "")
        )
      }
    } catch {
      self.errorMessage = "Failed to fetch profiles: \(error.localizedDescription)"
      self.showAlert = true
      return nil
    }
  }
  
  func fetchUnsyncedProfiles() -> [UserProfile] {
    return fetchProfiles()?.filter { $0.status != nil } ?? []
  }
  
  func markProfileAsSynced(_ profile: UserProfile) {
    updateProfile(user: profile)
  }
  
  
  func updateProfile(user: UserProfile) {
    let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
    do {
      let results = try container.viewContext.fetch(request)
      if let profileEntity = results.first {
        profileEntity.status = user.status?.rawValue
        saveContext()
      }
    } catch {
      print("Failed to update profile: \(error)")
    }
  }
  
  func saveProfiles(_ profiles: [UserProfile]) {
    let context = container.viewContext
    profiles.forEach { profile in
      let entity = ProfileEntity(context: context)
      entity.id = profile.id
      entity.name = profile.name
      entity.age = Int16(profile.age)
      entity.location = profile.location
      entity.imageURL = profile.imageUrl
      entity.status = profile.status?.rawValue
    }
    saveContext()
  }
  
  private func saveContext() {
    do {
      try container.viewContext.save()
    } catch {
      self.errorMessage = "Failed to save Core Data: \(error.localizedDescription)"
      self.showAlert = true
    }
  }
}
