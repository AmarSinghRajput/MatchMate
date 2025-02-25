import Alamofire
import SwiftUI
import Combine
import Network

class MatchViewModel: ObservableObject {
  @Published var profiles: [UserProfile] = []
  @Published var errorMessage: String?
  @Published var showAlert: Bool = false
  private var cancellables = Set<AnyCancellable>()
  private var persistenceController = PersistenceController.shared
  private let networkMonitor = NWPathMonitor()
  private let queue = DispatchQueue.global(qos: .background)
  
  init(persistenceController: PersistenceController = PersistenceController.shared) {
    self.persistenceController = persistenceController
  }
  
  init() {
    networkMonitor.pathUpdateHandler = { [weak self] path in
      if path.status == .satisfied {
        self?.syncOfflineData()
      }
    }
    networkMonitor.start(queue: queue)
  }
  
  func fetchProfiles() {
    if let savedProfiles = persistenceController.fetchProfiles() {
      profiles = savedProfiles
      if profiles.isEmpty {
        fetchFromAPI()
      }
    } else {
      fetchFromAPI()
    }
  }
  
  func fetchFromAPI() {
    AF.request("https://randomuser.me/api/?results=10")
      .validate()
      .publishDecodable(type: APIResponse.self)
      .tryMap { response in
        if let error = response.error {
          throw error
        }
        return response.value?.results ?? []
      }
      .map { (userProfiles: [UserProfileResponse]) in
        userProfiles.map { profile in
          UserProfile(
            name: profile.name.first + " " + profile.name.last,
            age: profile.dob.age,
            location: profile.location.city,
            imageUrl: profile.picture.large
          )
        }
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.objectWillChange.send()
          self?.errorMessage = "API Error: \(error.localizedDescription)"
          self?.showAlert = true
        case .finished:
          break
        }
      }, receiveValue: { [weak self] profiles in
        self?.profiles = profiles
        self?.persistenceController.saveProfiles(profiles)
      })
      .store(in: &cancellables)
  }
  
  func updateStatus(for user: UserProfile, status: MatchStatus) {
    if let index = profiles.firstIndex(where: { $0.id == user.id }) {
      print("Before Update: \(profiles[index].status?.rawValue ?? "None")")
      
      profiles[index].status = status
      persistenceController.updateProfile(user: profiles[index])
      
      print("After Update: \(profiles[index].status?.rawValue ?? "None")")
    }
  }
  
  
  func syncOfflineData() {
//  Need API to sync the data ince network is back
//    let unsyncedProfiles = persistenceController.fetchUnsyncedProfiles()
//    for profile in unsyncedProfiles {
//      let parameters: [String: Any] = [
//        "id": profile.id.uuidString,
//        "status": profile.status?.rawValue ?? ""
//      ]
//      
//      AF.request("https://APIddressTOSync", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        .validate()
//        .response { response in
//          if let error = response.error {
//            self.errorMessage = "Sync Error: \(error.localizedDescription)"
//            self.showAlert = true
//          } else {
//            self.persistenceController.markProfileAsSynced(profile)
//          }
//        }
//    }
  }
}
