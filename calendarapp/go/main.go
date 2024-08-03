package main

import (
	"database/sql"
	"log"
	"net"

	_ "github.com/go-sql-driver/mysql"
	authservice "github.com/saadaminj/calendarapp/authservice"
	eventservice "github.com/saadaminj/calendarapp/eventservice"
	loginservice "github.com/saadaminj/calendarapp/loginservice"
	pb "github.com/saadaminj/calendarapp/protos"
	"google.golang.org/grpc"
)


func main() {
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    db, err := sql.Open("mysql", "root:admin123@tcp(localhost:3306)/eventsdb")
    if err != nil {
        log.Fatalf("failed to connect to database: %v", err)
    }


    s := grpc.NewServer(
        grpc.UnaryInterceptor(authservice.UnaryAuthInterceptor()),
        grpc.StreamInterceptor(authservice.StreamAuthInterceptor()),)
    pb.RegisterEventServiceServer(s,eventservice.NewEventService(db) )
    pb.RegisterLoginServiceServer(s,loginservice.NewLoginService(db));
    log.Println("Starting server on :50051")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
