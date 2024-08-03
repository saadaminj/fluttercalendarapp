package authservice

import (
	"context"
	"fmt"
	"os"
	"strings"

	"github.com/golang-jwt/jwt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

var jwtKey = []byte(os.Getenv("JWT_KEY"))

type Claims struct {
    Username string `json:"username"`
    jwt.StandardClaims
}

func AuthInterceptor(ctx context.Context) (context.Context, error) {
    md, ok := metadata.FromIncomingContext(ctx)
    if !ok {
        return nil, status.Errorf(codes.Unauthenticated, "Missing metadata")
    }

    tokenStrs := md["authorization"]
    if len(tokenStrs) == 0 {
        return nil, status.Errorf(codes.Unauthenticated, "Missing token")
    }
    tokenStr := tokenStrs[0]

    tokenStr = strings.TrimPrefix(tokenStr, "Bearer ")
    if tokenStr == "" {
        return nil, status.Errorf(codes.Unauthenticated, "Bearer token missing")
    }

    token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(token *jwt.Token) (interface{}, error) {
        return jwtKey, nil
    })
    if err != nil || !token.Valid {
        return nil, status.Errorf(codes.Unauthenticated, "Invalid token: %v", err)
    }

    claims, ok := token.Claims.(*Claims)
    if !ok {
        return nil, status.Errorf(codes.Unauthenticated, "Invalid token claims")
    }
    newCtx := context.WithValue(ctx, "username", claims.Username)
    return newCtx, nil
}

func UnaryAuthInterceptor() grpc.UnaryServerInterceptor {
    return func(
        ctx context.Context,
        req interface{},
        info *grpc.UnaryServerInfo,
        handler grpc.UnaryHandler,
    ) (interface{}, error) {
        fmt.Println(info.FullMethod);
        // Apply authentication only to specific methods
        if info.FullMethod == "/login.LoginService/Login"  || info.FullMethod == "/login.LoginService/Signup" {
            // Skip authentication for Login method
            return handler(ctx, req)
        }
        ctx, err := AuthInterceptor(ctx)
        if err != nil {
            return nil, err
        }
        return handler(ctx, req)
    }
}

func StreamAuthInterceptor() grpc.StreamServerInterceptor {
    return func(
        srv interface{},
        stream grpc.ServerStream,
        info *grpc.StreamServerInfo,
        handler grpc.StreamHandler,
    ) error {
        // Apply authentication only to specific methods
        if info.FullMethod == "/LoginService/Login" {
            // Skip authentication for Login method
            return handler(srv, stream)
        }

        // Extract context from stream
        ctx, err := AuthInterceptor(stream.Context())
        if err != nil {
            return err
        }

        // Create a new ServerStream with modified context
        wrappedStream := &streamWrapper{
            ServerStream: stream,
            context:      ctx,
        }
        return handler(srv, wrappedStream)
    }
}

// streamWrapper is a wrapper around grpc.ServerStream that allows modification of the context.
type streamWrapper struct {
    grpc.ServerStream
    context context.Context
}

func (s *streamWrapper) Context() context.Context {
    return s.context
}
