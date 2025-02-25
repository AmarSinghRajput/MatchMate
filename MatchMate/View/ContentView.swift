import SwiftUI
import CoreData

struct ContentView: View {
  @StateObject var viewModel = MatchViewModel()
  @ObservedObject var persistenceController = PersistenceController.shared
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          ForEach(viewModel.profiles) { profile in
            MatchCardView(profile: profile) { status in
              viewModel.updateStatus(for: profile, status: status)
            }
          }
        }
        .padding()
      }
      .navigationTitle("MatchMate")
      .onAppear {
        viewModel.fetchProfiles()
      }
      .alert(isPresented: Binding<Bool>(
        get: { viewModel.showAlert || persistenceController.showAlert },
        set: { _ in
          viewModel.showAlert = false
          persistenceController.showAlert = false
        }
      )) {
        Alert(
          title: Text("Error"),
          message: Text(viewModel.errorMessage ?? persistenceController.errorMessage ?? "Unknown Error"),
          dismissButton: .default(Text("OK"))
        )
      }
    }
  }
}

#Preview {
  ContentView(viewModel: MatchViewModel())
}
