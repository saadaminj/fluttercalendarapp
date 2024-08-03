package eventservice

import (
	"context"
	"database/sql"
	"fmt"

	pb "github.com/saadaminj/calendarapp/protos"
)

type eventServer struct {
    pb.UnimplementedEventServiceServer
    db *sql.DB
}

func NewEventService(db *sql.DB) *eventServer {
    return &eventServer{
        db: db,
    }
}

func (s *eventServer) CreateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
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

func (s *eventServer) GetEventById(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
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

func (s *eventServer) UpdateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    _, err := s.db.ExecContext(ctx, "UPDATE events SET title=?, date=?, time=? WHERE id=?", event.GetTitle(), event.GetDate(), event.GetTime(), event.GetId())
    if err != nil {
        return nil, err
    }
    return &pb.EventResponse{Event: event}, nil
}

func (s *eventServer) DeleteEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    _, err := s.db.ExecContext(ctx, "DELETE FROM events WHERE id=?", event.GetId())
    if err != nil {
        return nil, err
    }
    return &pb.EventResponse{}, nil
}

func (s *eventServer) ListEvents(ctx context.Context, req *pb.EventRequest) (*pb.EventListResponse, error) {
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