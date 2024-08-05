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
var refreshSecret = []byte(os.Getenv("REFRESH_KEY"))

type Claims struct {
    Username string `json:"username"`
    jwt.StandardClaims
}

func (s *LoginServiceImpl) generateAccessToken(username string) (string, error) {
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

func generateRefreshToken(username string) (string, error) {
	expirationTime := time.Now().Add(7 * 24 * time.Hour)
	claims := &Claims{
		Username: username,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(refreshSecret)
}

func (s *LoginServiceImpl) RefreshTokenHandler(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
	_refreshToken := req.GetUser().RefreshToken;
	claims := &Claims{}
	token, err := jwt.ParseWithClaims(_refreshToken, claims, func(token *jwt.Token) (interface{}, error) {
		return refreshSecret, nil
	})

	if err != nil || !token.Valid {
        return &pb.LoginResponse{}, err
	}

	accessToken, err := s.generateAccessToken(claims.Username)
	if err != nil {
        return &pb.LoginResponse{}, err
	}

	refreshToken, err := generateRefreshToken(claims.Username)
	if err != nil {
        return &pb.LoginResponse{}, err
	}

    return &pb.LoginResponse{User: &pb.User{Token:accessToken,RefreshToken: refreshToken}}, err


}

func (s *LoginServiceImpl) Login(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
    var user1 pb.User;
	user := req.GetUser()
    err := s.db.QueryRow("SELECT id, firstname, lastname, username, password, email FROM users WHERE username = ?", user.Username).Scan(&user1.UserId, &user1.Firstname, &user1.Lastname, &user1.Username, &user1.Password, &user1.Email)
    if err != nil {
        if err == sql.ErrNoRows {
            return &pb.LoginResponse{}, errors.New("user not found")
        }
        return &pb.LoginResponse{}, err
    }

    if !CheckPasswordHash(user.Password, user1.Password) {
        return &pb.LoginResponse{}, errors.New("invalid credentials")
    }
	token, err := s.generateAccessToken(user.Username)
    if err != nil {
        return nil, err
    }
    refreshToken, err := generateRefreshToken(user.Username)
	if err != nil {
        return &pb.LoginResponse{}, err
	}
	user1.Token = token;
    user1.Password = "";
    user1.RefreshToken = refreshToken;

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
    result, err := s.db.Exec("INSERT INTO users (firstname, lastname, username, password, email) VALUES (?, ?, ?, ?, ?)", user.Firstname, user.Lastname, user.Username, hash, user.Email)
    if err != nil {
        return &pb.LoginResponse{}, err
    }

    // Get the last inserted ID
    id, err := result.LastInsertId()
    if err != nil {
        return nil, err
    }

    // Set the ID of the user
    user.UserId = id;

	token, err := s.generateAccessToken(user.Username)
    if err != nil {
        return nil, err
    }
    
    refreshToken, err := generateRefreshToken(user.Username)
	if err != nil {
        return &pb.LoginResponse{}, err
	}

	user.Token = token;
    user.Password = "";
    user.RefreshToken = refreshToken;

    return &pb.LoginResponse{User: user}, nil
}
