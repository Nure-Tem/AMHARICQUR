# Database Design

## Overview

Single SQLite database (`amharic_qur.db`) with **read-only book content** and **mutable user data** tables. Book content ships as a pre-built asset; user tables are created on first launch.

## Entity Relationship

```
book_content (1) ──< (N) bookmarks
book_content (1) ──< (N) highlights
book_content (1) ──< (N) notes
highlights   (1) ──< (0..N) notes
book_content (1) ──< (N) reading_history
settings (key-value, standalone)
book_content_fts (FTS5 virtual, mirrors book_content)
```

---

## Table: `book_content`

Immutable structured book blocks. Preserves exact text, order, and styling.

| Column          | Type    | Description                                      |
|-----------------|---------|--------------------------------------------------|
| id              | INTEGER | Primary key                                      |
| parent_id       | INTEGER | Parent block for hierarchy (TOC tree)            |
| type            | TEXT    | `bookTitle`, `surahTitle`, `arabicVerse`, etc.   |
| sort_order      | INTEGER | Global reading order (critical for lazy load)    |
| level           | INTEGER | Heading depth (1–6)                              |
| text_ar         | TEXT    | Arabic text (verbatim)                           |
| text_am         | TEXT    | Amharic text (verbatim)                          |
| style_json      | TEXT    | Colors, fonts, margins, alignment, decorations   |
| metadata_json   | TEXT    | Surah/ayah numbers, page refs, etc.              |
| content_hash    | TEXT    | Integrity checksum (optional)                    |

**Indexes:** `sort_order`, `parent_id`, `type`

---

## Table: `book_content_fts` (FTS5)

Fast full-text search across Arabic, Amharic, and titles.

| Column      | Type   | Description                    |
|-------------|--------|--------------------------------|
| content_id  | INT    | UNINDEXED — links to book_content |
| title       | TEXT   | Indexed heading/title text     |
| text_ar     | TEXT   | Indexed Arabic content         |
| text_am     | TEXT   | Indexed Amharic content        |

**Tokenizer:** `unicode61` (supports Arabic script)

**Triggers:** Auto-sync on INSERT/UPDATE/DELETE of `book_content`

---

## Table: `bookmarks`

| Column            | Type    | Description                |
|-------------------|---------|----------------------------|
| id                | TEXT    | UUID primary key           |
| content_block_id  | INTEGER | FK → book_content.id       |
| char_offset       | INTEGER | Optional in-block position |
| custom_name       | TEXT    | User-defined label         |
| preview_text      | TEXT    | Snapshot for list display  |
| created_at        | INTEGER | Epoch ms                   |
| updated_at        | INTEGER | Epoch ms                   |

**Sort:** `created_at DESC` (newest first)

---

## Table: `highlights`

Overlay metadata — **never modifies** `book_content` text.

| Column              | Type    | Description                          |
|---------------------|---------|--------------------------------------|
| id                  | TEXT    | UUID                                 |
| content_block_id    | INTEGER | FK → book_content.id                 |
| char_offset_start   | INTEGER | Start offset in block text           |
| char_offset_end     | INTEGER | End offset (exclusive)               |
| color               | TEXT    | `yellow`, `green`, `blue`, `pink`, `orange` |
| selected_text       | TEXT    | Display snapshot of highlighted text |
| created_at          | INTEGER | Epoch ms                             |
| updated_at          | INTEGER | Epoch ms                             |

---

## Table: `notes`

| Column              | Type    | Description                    |
|---------------------|---------|--------------------------------|
| id                  | TEXT    | UUID                           |
| highlight_id        | TEXT    | Optional FK → highlights.id    |
| content_block_id    | INTEGER | FK → book_content.id           |
| char_offset_start   | INTEGER | Optional anchor                |
| char_offset_end     | INTEGER | Optional anchor                |
| note_text           | TEXT    | User's personal note           |
| created_at          | INTEGER | Epoch ms                       |
| updated_at          | INTEGER | Epoch ms                       |

---

## Table: `reading_history`

| Column               | Type    | Description                         |
|----------------------|---------|-------------------------------------|
| id                   | INTEGER | Auto-increment PK                   |
| content_block_id     | INTEGER | FK → book_content.id                |
| scroll_offset        | REAL    | Pixel scroll position               |
| scroll_fraction      | REAL    | 0.0–1.0 normalized position         |
| char_offset          | INTEGER | Optional text anchor                |
| section_title        | TEXT    | Denormalized for recent list UI     |
| visited_at           | INTEGER | Epoch ms                            |
| is_continue_reading  | INTEGER | 1 = active continue-reading entry   |

Only one row should have `is_continue_reading = 1` at a time.

---

## Table: `settings`

Key-value store for app preferences.

| Column     | Type | Description   |
|------------|------|---------------|
| key        | TEXT | Setting name  |
| value      | TEXT | Serialized value |
| updated_at | INT  | Epoch ms      |

**Known keys:** `theme_mode`, `reader_font_scale`, `reader_line_height`, `keep_screen_on`, `default_highlight_color`

---

## Lazy Loading Query Pattern

```sql
SELECT * FROM book_content
WHERE sort_order >= ? AND sort_order < ?
ORDER BY sort_order ASC
LIMIT ?;
```

## Search Query Pattern (FTS5)

```sql
SELECT bc.id, bc.sort_order, snippet(book_content_fts, 2, '<b>', '</b>', '...', 32) AS snippet,
       bm25(book_content_fts) AS rank
FROM book_content_fts
JOIN book_content bc ON bc.id = book_content_fts.content_id
WHERE book_content_fts MATCH ?
ORDER BY rank
LIMIT 100;
```
