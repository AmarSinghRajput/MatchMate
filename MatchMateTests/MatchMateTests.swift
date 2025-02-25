import XCTest
import Combine
@testable import MatchMate

class MatchViewModelTests: XCTestCase {
  var viewModel: MatchViewModel!
  var mockPersistenceController: MockPersistenceController!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockPersistenceController = MockPersistenceController()
    viewModel = MatchViewModel(persistenceController: mockPersistenceController)
    cancellables = []
  }
  
  override func tearDown() {
    viewModel = nil
    mockPersistenceController = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testFetchProfiles_FromCoreData() {
    mockPersistenceController.mockProfiles = [
      UserProfile(name: "John Doe", age: 30, location: "New York", imageUrl: "https://example.com", status: .accepted)
    ]
    
    viewModel.fetchProfiles()
    
    XCTAssertEqual(viewModel.profiles.count, 1)
    XCTAssertEqual(viewModel.profiles.first?.name, "John Doe")
  }
  
  func testFetchProfiles_FromAPI() {
          let expectation = XCTestExpectation(description: "Fetch API call completes")
          
          viewModel.fetchFromAPI()
          
          viewModel.$profiles
              .dropFirst()
              .sink(receiveValue: { profiles in
                  XCTAssertFalse(profiles.isEmpty, "Profiles should be fetched from API")
                  expectation.fulfill()
              })
              .store(in: &cancellables)
          
          wait(for: [expectation], timeout: 5)
      }
  
  func testUpdateProfileStatus() {
    let profile = UserProfile(name: "Jane Doe", age: 28, location: "California", imageUrl: "https://example.com")
    viewModel.profiles = [profile]
    
    viewModel.updateStatus(for: profile, status: .declined)
    
    XCTAssertEqual(viewModel.profiles.first?.status, .declined)
  }
}

class MockPersistenceController: PersistenceController {
  var mockProfiles: [UserProfile] = []
  
  override func fetchProfiles() -> [UserProfile]? {
    return mockProfiles
  }
  
  override func saveProfiles(_ profiles: [UserProfile]) {
    mockProfiles = profiles
  }
  
  override func updateProfile(user: UserProfile) {
    if let index = mockProfiles.firstIndex(where: { $0.id == user.id }) {
      mockProfiles[index] = user
    }
  }
}
