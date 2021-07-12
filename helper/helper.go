package helper

import "strings"

// decides whether it's unpacking by key name
// hard-coded and reverse-engineered for now
func IsExtract(key string) bool {
	// Example key: "default/19/extract-670169156-XAto sha256:e3a7caf66088cd4176b05a738d5d075dc2b6177104627dd963540b95c2b288b4"
	//return strings.Contains(key, "extract")
	parts := strings.Split(key, " ")
	if len(parts) != 2 {
		return false
	}
	segments := strings.Split(parts[0], "/")
	if len(segments) != 3 {
		return false
	}
	return strings.HasPrefix(segments[2], "extract-")
}
