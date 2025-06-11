# Instagram Story Mock

## 📸 Screenshots

<p align=center>
  <img src="https://github.com/user-attachments/assets/4c2d4c02-e69c-4c62-bbf1-d35a63f00cc7" width=200>
  <img src="https://github.com/user-attachments/assets/0832f676-8fb1-4989-b613-00aa5f6a8d93" width=200>
</p>

https://github.com/user-attachments/assets/5b9b012e-6e03-4ab2-9cc2-eefcda6b050f

## 🏗️ Architecture

This application follows a clean, layered architecture pattern:
![Architecture](https://github.com/user-attachments/assets/d7db2545-d5bd-47a0-b65c-727758e60cb3)

### Data Layer
- **likeStorage**: Handles like/reaction data persistence
- **seenStorage**: Manages story view tracking
- **UsersServices**: User data management and API calls

### Domain Layer (Business Logic)
- **LikedPostsRepository**: Business logic for post interactions
- **SeenPostsRepository**: Story view state management
- **UsersRepository**: User data operations
- **StoryRepository**: Story content management
- **LikedPostsUseCase**: Like/unlike functionality
- **StoryUseCase**: Story retrieval logic

### Presentation Layer
- **StoryViewModel**: Story-specific UI state management
- **HomeViewModel**: Main feed UI state management
- **StoryView**: Story display interface
- **HomeView**: Main application interface
