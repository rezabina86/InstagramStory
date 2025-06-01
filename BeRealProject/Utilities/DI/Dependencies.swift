import Foundation

public func injectDependencies(into container: ContainerType) {
    
    container.register(in: .container) { container -> HTTPClientType in
        MockUsersHTTPClient()
    }
    
    container.register { container -> UsersServiceType in
        UsersService(client: container.resolve(),
                     jsonDecoder: JSONDecoder())
    }
    
    container.register { _ -> UserDefaultsType in
        UserDefaults.standard
    }
    
    container.register { container -> LikedItemsStorageType in
        LikedItemsStorage(userDefaults: container.resolve())
    }
    
    container.register { container -> SeenStorageType in
        SeenStorage(userDefaults: container.resolve())
    }
    
    container.register(in: .weakContainer) { container -> LikedPostsRepositoryType in
        LikedPostsRepository(storage: container.resolve())
    }
    
    container.register(in: .weakContainer) { container -> SeenPostsRepositoryType in
        SeenPostsRepository(storage: container.resolve())
    }
    
    container.register { container -> StoryRepositoryType in
        StoryRepository()
    }
    
    container.register(in: .weakContainer) { container -> UsersRepositoryType in
        UsersRepository(service: container.resolve())
    }
    
    container.register { container -> StoryUseCaseType in
        StoryUseCase(usersRepository: container.resolve(),
                     likedRepository: container.resolve(),
                     seenRepository: container.resolve(),
                     storyRepository: container.resolve())
    }
    
    container.register { container -> StoryViewModelFactoryType in
        StoryViewModelFactory(storyUseCase: container.resolve(),
                              modalCoordinator: container.resolve(),
                              seenRepository: container.resolve(),
                              likedPostsUseCase: container.resolve())
    }
    
    container.register(in: .weakContainer) { _ -> ModalCoordinatorType in
        ModalCoordinator()
    }
    
    container.register(in: .weakContainer) { container -> LikedPostsUseCaseType in
        LikedPostsUseCase(repository: container.resolve())
    }
    
    container.register { container -> HomeViewModelFactoryType in
        HomeViewModelFactory(storyUseCase: container.resolve(),
                             storyViewModelFactory: container.resolve(),
                             modalCoordinator: container.resolve())
    }
}

