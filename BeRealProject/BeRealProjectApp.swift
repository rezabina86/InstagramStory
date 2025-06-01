import SwiftUI

@main
struct BeRealProjectApp: App {
    init(container: ContainerType) {
        self.container = container
        configureDependencies(container)
        homeViewModelFactory = container.resolve()
    }
    
    init() {
        self.init(container: Container())
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModelFactory.create())
        }
    }
    
    private let container: ContainerType
    private var configureDependencies = injectDependencies
    private let homeViewModelFactory: HomeViewModelFactoryType
}
