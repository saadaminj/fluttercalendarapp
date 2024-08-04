package loginservice

import (
	"context"
	"database/sql"
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt"
	pb "github.com/saadaminj/calendarapp/protos"
	"golang.org/x/crypto/bcrypt"
)

type LoginServiceImpl struct {
	pb.UnimplementedLoginServiceServer
    db *sql.DB
}   

// HashPassword hashes the given password using bcrypt
func HashPassword(password string) (string, error) {
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
    return string(bytes), err
}

// CheckPasswordHash checks if the provided password matches the hashed password
func CheckPasswordHash(password, hash string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}

func NewLoginService(db *sql.DB) *LoginServiceImpl {
    return &LoginServiceImpl{
        db: db,
    }
}

var jwtKey = []byte(os.Getenv("JWT_KEY"))

type Claims struct {
    Username string `json:"username"`
    jwt.StandardClaims
}

func (s *LoginServiceImpl) generateJWT(username string) (string, error) {
    expirationTime := time.Now().Add(1 * time.Hour)
    claims := &Claims{
        Username: username,
        StandardClaims: jwt.StandardClaims{
            ExpiresAt: expirationTime.Unix(),
        },
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString(jwtKey)
}

func (s *LoginServiceImpl) Login(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
    var user1 pb.User;
	user := req.GetUser()
    err := s.db.QueryRow("SELECT firstname, lastname, username, password, email FROM users WHERE username = ?", user.Username).Scan(&user1.Firstname, &user1.Lastname, &user1.Username, &user1.Password, &user1.Email)
    if err != nil {
        if err == sql.ErrNoRows {
            return &pb.LoginResponse{}, errors.New("user not found")
        }
        return &pb.LoginResponse{}, err
    }

    if CheckPasswordHash(user.Password, user1.Password) {
        return &pb.LoginResponse{}, errors.New("invalid credentials")
    }
	token, err := s.generateJWT(user.Username)
    if err != nil {
        return nil, err
    }
	user1.Token = token;
    user1.Password = "";

    return &pb.LoginResponse{User: &user1}, nil
}

func (s *LoginServiceImpl) Signup(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
    // Check if user already exists
    var existingUser pb.User
	var user = req.GetUser()
    err := s.db.QueryRow("SELECT username FROM users WHERE username = ?", user.Username).Scan(&existingUser.Username)
    if err == nil {
        return &pb.LoginResponse{}, errors.New("user already exists")
    } else if err != sql.ErrNoRows {
        return &pb.LoginResponse{}, err
    }

    hash, err := HashPassword(user.Password)
    if err != nil {
        return &pb.LoginResponse{}, err
    }

    // Insert new user
    _, err = s.db.Exec("INSERT INTO users (firstname, lastname, username, password, email) VALUES (?, ?, ?, ?, ?)", user.Firstname, user.Lastname, user.Username, hash, user.Email)
    if err != nil {
        return &pb.LoginResponse{}, err
    }

	token, err := s.generateJWT(user.Username)
    if err != nil {
        return nil, err
    }
	user.Token = token;
    user.Password = "";

    return &pb.LoginResponse{User: user}, nil
}
