# Amharic Qur — Architecture

## Overview

Production Flutter app for offline structured Islamic book reading. Content is rendered natively (not PDF) while preserving original typography, hierarchy, and reading order.

## Layers (Clean Architecture + MVVM)

```
┌─────────────────────────────────────────────────────────────┐
│  Presentation (MVVM)                                        │
│  Screens · Widgets · ViewModels (Riverpod Notifiers)        │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  Domain                                                     │
│  Entities · Repository Interfaces · Enums                   │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  Data                                                       │
│  Repository Impls · DAOs · Local Data Sources · DTO Models  │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  Core                                                       │
│  Theme · Navigation · Constants · Errors · Extensions       │
└─────────────────────────────────────────────────────────────┘
```

## Folder Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── enums/
│   ├── errors/
│   ├── extensions/
│   ├── navigation/
│   ├── theme/
│   └── utils/
├── data/
│   ├── datasources/local/
│   │   ├── database/
│   │   └── daos/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── di/
    └── injection.dart
```

## Data Flow

1. **Book content** ships as a pre-built SQLite asset (`assets/database/book.db`), copied on first launch.
2. **Reader** loads content blocks lazily by `sort_order` range (pagination windows).
3. **Highlights / notes** store character offsets against immutable `content_block_id` — never alter book text.
4. **Search** uses SQLite FTS5 (`book_content_fts`) for Arabic, Amharic, and titles.
5. **Reading position** auto-saves scroll offset + block anchor on pause/background.

## State Management

| Concern              | Provider Type        |
|----------------------|----------------------|
| Theme / settings     | `NotifierProvider`   |
| Reader content       | `AsyncNotifierProvider` |
| Search               | `AsyncNotifierProvider` |
| Bookmarks / highlights | `AsyncNotifierProvider` |
| Navigation           | `go_router` + `Provider` |

## Performance Strategy

- Lazy-loaded `ListView.builder` with block windowing (e.g. 50 blocks per fetch).
- FTS5 index for sub-100ms search on large corpora.
- `RepaintBoundary` per content block in reader (presentation phase).
- Debounced scroll position persistence (500ms).
- Separate user-data DB tables from read-only content tables.

## Screens (planned)

| Route            | Screen              |
|------------------|---------------------|
| `/`              | Splash              |
| `/home`          | Home                |
| `/toc`           | Table of Contents   |
| `/reader`        | Reader              |
| `/search`        | Search              |
| `/bookmarks`     | Bookmarks           |
| `/highlights`    | Highlights & Notes  |
| `/settings`      | Settings            |
| `/about`         | About               |
