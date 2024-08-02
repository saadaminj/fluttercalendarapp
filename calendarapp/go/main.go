package main

import (
    "context"
    "fmt"
    "database/sql"
    "google.golang.org/grpc"
    pb "github.com/saadaminj/calendarapp/protos"
    _ "github.com/go-sql-driver/mysql"
    "log"
    "net"
)

type server struct {
    pb.UnimplementedEventServiceServer
    db *sql.DB
}

func (s *server) CreateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    res, err := s.db.ExecContext(ctx, "INSERT INTO events (id, title, date, time) VALUES (?, ?, ?, ?)", event.GetId(), event.GetTitle(), event.GetDate(), event.GetTime())
    if err != nil {
        return nil, err
    }
    id, err := res.LastInsertId()
    if err != nil {
        return nil, err
    }
    event.Id = int32(id)
    return &pb.EventResponse{Event: event}, nil
}

func (s *server) GetEventById(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    row := s.db.QueryRowContext(ctx, "SELECT id, title, date, time FROM events WHERE id=?", event.GetId())
    err := row.Scan(&event.Id, &event.Title, &event.Date, &event.Time)
    if err != nil {
        if err == sql.ErrNoRows {
            return nil, fmt.Errorf("event not found")
        }
        return nil, err
    }
    return &pb.EventResponse{Event: event}, nil
}

func (s *server) UpdateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    _, err := s.db.ExecContext(ctx, "UPDATE events SET title=?, date=?, time=? WHERE id=?", event.GetTitle(), event.GetDate(), event.GetTime(), event.GetId())
    if err != nil {
        return nil, err
    }
    return &pb.EventResponse{Event: event}, nil
}

func (s *server) DeleteEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    _, err := s.db.ExecContext(ctx, "DELETE FROM events WHERE id=?", event.GetId())
    if err != nil {
        return nil, err
    }
    return &pb.EventResponse{}, nil
}

func (s *server) ListEvents(ctx context.Context, req *pb.EventRequest) (*pb.EventListResponse, error) {
    rows, err := s.db.QueryContext(ctx, "SELECT id, title, date, time FROM events")
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var events []*pb.Event
    for rows.Next() {
        var event pb.Event
        if err := rows.Scan(&event.Id, &event.Title, &event.Date, &event.Time); err != nil {
            return nil, err
        }
        events = append(events, &event)
    }
    if err := rows.Err(); err != nil {
        return nil, err
    }

    return &pb.EventListResponse{Events: events}, nil
}

func main() {
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    db, err := sql.Open("mysql", "root:admin123@tcp(localhost:3306)/eventsdb")
    if err != nil {
        log.Fatalf("failed to connect to database: %v", err)
    }
    s := grpc.NewServer()
    pb.RegisterEventServiceServer(s, &server{db: db})
    log.Println("Starting server on :50051")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
