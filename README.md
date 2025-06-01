# 📱 Story Feature

## 🧭 Architecture Overview

---

<img width="1684" src="https://github.com/user-attachments/assets/47f4a63c-1268-46da-84c3-6f9e179a2782" />


## 🧱 Layers

### 🔹 Data Layer

Handles local persistence and remote communication.

| Component       | Responsibility                                      |
|----------------|------------------------------------------------------|
| `likeStorage`   | Stores liked post IDs locally.                      |
| `seenStorage`   | Stores seen post/story IDs.                         |
| `UsersServices` | Fetches user data from mock APIs via HTTPClient. |

---

### 🔹 Domain Layer (Business Logic)

Contains the business rules and interfaces.

| Component              | Responsibility                                       |
|------------------------|-----------------------------------------------------|
| `LikedPostsRepository` | Returns stream of liked posts.                      |
| `SeenPostsRepository`  | Returns stream of seen posts.                       |                              |
| `StoryRepository`      | Creates and returns story resource for a user       |
| `LikedPostsUseCase`    | Toggles liked state of stories.                     |
| `StoryUseCase`         | Combines all repos and create a composable model    |

---

It was quite challenging to finish everything within 4 hours. I decided to skip implementing pagination for now, so it only displays page 0. Also, `AsyncImage` occasionally fails to load the image, and I wasn’t able to debug the issue before the task deadline.
