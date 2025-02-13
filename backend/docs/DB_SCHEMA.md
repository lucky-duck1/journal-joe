
## Firestore Collection: `articles`

Each document represents an article with the following fields:

- **title** (string): Article title. Required.
- **content** (string): Main content. Required.
- **authorId** (string): Firebase UID of the author. Must match the authenticated user. Required.
- **authorName** (string): Author's display name. Required.
- **publishedAt** (timestamp): Publication date and time. Required.
- **thumbnailURL** (string): Cloud Storage path starting with `media/articles/`. Required.
- **summary** (string): Brief summary. Optional.
- **categories** (array of strings): Article tags. Optional.
- **createdAt** (timestamp): Auto-generated on creation.
- **updatedAt** (timestamp): Auto-updated on modification.

## Cloud Storage

Thumbnails are stored in `media/articles/{articleId}/` with a filename (e.g., `thumbnail.jpg`). The `articleId` corresponds to the Firestore document ID.