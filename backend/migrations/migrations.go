package migrations

import (
	"embed"
	"io/fs"
)

// Files contains every SQL migration shipped with the backend.
// The repository applies them in filename order at startup.
//
//go:embed *.sql
var Files embed.FS

func SQLFiles() ([]string, error) {
	var files []string
	err := fs.WalkDir(Files, ".", func(path string, entry fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if !entry.IsDir() && len(path) >= 4 && path[len(path)-4:] == ".sql" {
			files = append(files, path)
		}
		return nil
	})
	return files, err
}
