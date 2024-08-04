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
    user := req.GetUser()
    res, err := s.db.ExecContext(ctx, "INSERT INTO events (id, title, date, time, userId) VALUES (?, ?, ?, ?)", event.GetId(), event.GetTitle(), event.GetDate(), event.GetTime(), user.GetUserId())
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
    event := req.GetEvent();
    user := req.GetUser();
    row := s.db.QueryRowContext(ctx, "SELECT id, title, date, time, userId FROM events WHERE id=? AND userId=?", event.GetId(),user.GetUserId())
    err := row.Scan(&event.Id, &event.Title, &event.Date, &event.Time, &event.UserId)
    if err != nil {
        if err == sql.ErrNoRows {
            return nil, fmt.Errorf("event not found")
        }
        return nil, err
    }
    return &pb.EventResponse{Event: event}, nil
}

func (s *eventServer) UpdateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent();
    user := req.GetUser();
    _, err := s.db.ExecContext(ctx, "UPDATE events SET title=?, date=?, time=? WHERE id=? AND userId=?", event.GetTitle(), event.GetDate(), event.GetTime(), event.GetId(), user.GetUserId())
    if err != nil {
        return nil, err
    }
    return &pb.EventResponse{Event: event}, nil
}

func (s *eventServer) DeleteEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    user := req.GetUser();
    _, err := s.db.ExecContext(ctx, "DELETE FROM events WHERE id=? AND userId= ?", event.GetId(),user.GetUserId())
    if err != nil {
        return nil, err
    }
    return &pb.EventResponse{}, nil
}

func (s *eventServer) ListEvents(ctx context.Context, req *pb.EventRequest) (*pb.EventListResponse, error) {
    user := req.GetUser();
    rows, err := s.db.QueryContext(ctx, "SELECT id, title, date, time, userId FROM events WHERE userId=?", user.GetUserId())
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var events []*pb.Event
    for rows.Next() {
        var event pb.Event
        if err := rows.Scan(&event.Id, &event.Title, &event.Date, &event.Time, &event.UserId); err != nil {
            return nil, err
        }
        events = append(events, &event)
    }
    if err := rows.Err(); err != nil {
        return nil, err
    }

    return &pb.EventListResponse{Events: events}, nil
}