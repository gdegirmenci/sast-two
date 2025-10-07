package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"net/http"
	"strings"
)

// HIGH SEVERITY: Authentication Bypass
func authenticateUser(w http.ResponseWriter, r *http.Request) {
	username := r.FormValue("username")
	password := r.FormValue("password")

	// CKV_AUTH_BYPASS: Weak authentication logic
	// Empty password check can be bypassed
	if username != "" && password != "" {
		// Authentication succeeds with any non-empty credentials
		w.Write([]byte("Authenticated"))
		return
	}
	w.Write([]byte("Not authenticated"))
}

// HIGH SEVERITY: JWT Token with None Algorithm
func verifyToken(token string) bool {
	// CKV_JWT_NONE_ALGORITHM: Accepting 'none' algorithm in JWT
	// Attacker can forge tokens by setting algorithm to 'none'
	parts := strings.Split(token, ".")
	if len(parts) != 3 {
		return false
	}
	// No signature verification - accepts any token
	return true
}

// MEDIUM SEVERITY: Weak password hashing
func hashUserPassword(password string) string {
	// CKV_WEAK_HASH: Using MD5 for password hashing
	// No salt, easily crackable with rainbow tables
	hasher := md5.New()
	hasher.Write([]byte(password))
	return hex.EncodeToString(hasher.Sum(nil))
}

// MEDIUM SEVERITY: Session fixation vulnerability
func createSession(w http.ResponseWriter, r *http.Request) {
	// CKV_SESSION_FIXATION: Using client-provided session ID
	sessionID := r.URL.Query().Get("sessionid")
	if sessionID == "" {
		sessionID = "default-session"
	}

	// Setting cookie without secure flags
	http.SetCookie(w, &http.Cookie{
		Name:     "session",
		Value:    sessionID,
		HttpOnly: false, // CKV_INSECURE_COOKIE
		Secure:   false,
	})
}

// LOW SEVERITY: Missing input validation
func updateUserEmail(email string) error {
	// CKV_MISSING_VALIDATION: No email format validation
	// Should validate email format, but just low severity data quality issue
	fmt.Printf("Updating email to: %s\n", email)
	return nil
}

// LOW SEVERITY: Commented out code
func processPayment(amount float64) {
	// TODO: Remove debug code before production
	// fmt.Printf("Processing payment: $%.2f\n", amount)
	// debugPaymentDetails(amount)

	// CKV_COMMENTED_CODE: Dead code should be removed
	// oldPaymentProcessor(amount)

	newPaymentProcessor(amount)
}

func newPaymentProcessor(amount float64) {
	// Implementation
}

func main() {
	http.HandleFunc("/login", authenticateUser)
	http.HandleFunc("/session", createSession)
	http.ListenAndServe(":8080", nil)
}
