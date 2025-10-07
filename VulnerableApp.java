import java.sql.*;
import java.io.*;
import javax.servlet.http.*;
import java.util.Random;

public class VulnerableApp {

    // SQL Injection vulnerability
    public User getUserById(String userId) throws SQLException {
        // CKV_SQL_INJECTION: String concatenation in SQL query
        Connection conn = getConnection();
        Statement stmt = conn.createStatement();
        String query = "SELECT * FROM users WHERE id = '" + userId + "'";
        ResultSet rs = stmt.executeQuery(query);
        return parseUser(rs);
    }

    // Hardcoded credentials
    private Connection getConnection() throws SQLException {
        // CKV_SECRET: Hardcoded database credentials
        String url = "jdbc:mysql://localhost:3306/mydb";
        String username = "root";
        String password = "P@ssw0rd123";
        return DriverManager.getConnection(url, username, password);
    }

    // Command injection vulnerability
    public void backupFile(String filename) throws IOException {
        // CKV_COMMAND_INJECTION: Unsanitized input in system command
        Runtime runtime = Runtime.getRuntime();
        String command = "tar -czf backup.tar.gz " + filename;
        runtime.exec(command);
    }

    // Weak random number generator
    public String generateSessionToken() {
        // CKV_INSECURE_RANDOM: Using java.util.Random for security token
        Random random = new Random();
        return String.valueOf(random.nextLong());
    }

    // Insecure deserialization
    public Object deserializeData(InputStream input) throws Exception {
        // CKV_DESERIALIZATION: Deserializing untrusted data
        ObjectInputStream ois = new ObjectInputStream(input);
        return ois.readObject();
    }

    // Weak cryptographic hash
    public String hashPassword(String password) throws Exception {
        // CKV_INSECURE_HASHES: Using weak MD5 hash for passwords
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
        byte[] hash = md.digest(password.getBytes());
        return bytesToHex(hash);
    }

    // Path traversal vulnerability
    public File readUserFile(HttpServletRequest request) {
        // CKV_PATH_TRAVERSAL: No validation of file path
        String filename = request.getParameter("file");
        return new File("/var/data/" + filename);
    }

    private User parseUser(ResultSet rs) throws SQLException {
        return new User();
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    class User {}
}
