import Foundation

struct UserProfile: Identifiable, Codable {
  let id: UUID
  let name: String
  let age: Int
  let location: String
  let imageUrl: String
  var status: MatchStatus?
  
  init(id: UUID = UUID(), name: String, age: Int, location: String, imageUrl: String, status: MatchStatus? = nil) {
    self.id = id
    self.name = name
    self.age = age
    self.location = location
    self.imageUrl = imageUrl
    self.status = status
  }
}

enum MatchStatus: String, Codable {
  case accepted = "Accepted"
  case declined = "Declined"
}

struct APIResponse: Codable {
  let results: [UserProfileResponse]
}

struct UserProfileResponse: Codable {
  let name: Name
  let dob: DOB
  let location: Location
  let picture: Picture
  
  struct Name: Codable {
    let first: String
    let last: String
  }
  
  struct DOB: Codable {
    let age: Int
  }
  
  struct Location: Codable {
    let city: String
  }
  
  struct Picture: Codable {
    let large: String
  }
}
