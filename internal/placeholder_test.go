package core

import "testing"

func TestPlaceholder(t *testing.T) {
	if !Placeholder() {
		t.Fatal("Placeholder should return true")
	}
}
