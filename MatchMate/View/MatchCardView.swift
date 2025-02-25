import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
  var profile: UserProfile
  var action: (MatchStatus) -> Void
  
  var body: some View {
    VStack {
      WebImage(url: URL(string: profile.imageUrl))
        .resizable()
        .scaledToFill()
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
      
      Text("\(profile.name), \(profile.age)")
        .font(.headline)
        .foregroundColor(.primary)
      
      Text(profile.location)
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      if let status = profile.status {
        Text(status.rawValue)
          .padding()
          .frame(maxWidth: .infinity)
          .background(status == .accepted ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
          .foregroundColor(.white)
          .cornerRadius(10)
          .disabled(true)
      }else {
        HStack {
          Button(action: { action(.declined) }) {
            Text(Image(systemName: "xmark.circle"))
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.red.opacity(0.7))
              .foregroundColor(.white)
              .cornerRadius(10)
          }
          
          Button(action: { action(.accepted) }) {
            Text(Image(systemName: "checkmark.circle"))
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.green.opacity(0.7))
              .foregroundColor(.white)
              .cornerRadius(10)
          }
        }
        
      }
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 3))
    .padding()
  }
}

#Preview {
  let profile: UserProfile = .init(
    name: "First Last",
    age: 30,
    location: "California",
    imageUrl: "https://picsum.photos/id/237/200/300"
  )
  
  return MatchCardView(profile: profile,action: { _ in })
}
