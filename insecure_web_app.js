const express = require('express');
const fs = require('fs');
const app = express();

// Path traversal vulnerability
app.get('/download', (req, res) => {
    // CKV_PATH_TRAVERSAL: Unsanitized user input in file path
    const filename = req.query.file;
    const filepath = '/var/www/files/' + filename;
    res.sendFile(filepath);
});

// XSS vulnerability
app.get('/search', (req, res) => {
    // CKV_XSS: Unsanitized user input rendered in HTML
    const searchTerm = req.query.q;
    res.send(`<h1>Search results for: ${searchTerm}</h1>`);
});

// Insecure cookie settings
app.get('/login', (req, res) => {
    // CKV_INSECURE_COOKIE: Cookie without secure flag
    res.cookie('session', 'user123', {
        httpOnly: false,
        secure: false,  // Not using HTTPS
        sameSite: 'none'
    });
    res.send('Logged in');
});

// Eval usage - code injection vulnerability
function processUserInput(userCode) {
    // CKV_CODE_INJECTION: Using eval with user input
    return eval(userCode);
}

// Hardcoded API key
const API_KEY = 'sk-1234567890abcdef1234567890abcdef';  // CKV_SECRET

// Using outdated crypto
const crypto = require('crypto');
function encryptData(data) {
    // CKV_WEAK_CIPHER: Using weak DES cipher
    const cipher = crypto.createCipher('des', 'weak-key');
    return cipher.update(data, 'utf8', 'hex') + cipher.final('hex');
}

app.listen(3000);
