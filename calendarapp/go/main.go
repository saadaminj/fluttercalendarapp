package main

import (
    "context"
    "fmt"
    "google.golang.org/grpc"
    pb "github.com/saadaminj/calendarapp/protos" // Import the generated protobuf package
    "log"
    "net"
)

type server struct {
    pb.UnimplementedEventServiceServer
}

var events = make(map[int32]*pb.Event)

func (s *server) CreateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    events[event.GetId()] = event
    return &pb.EventResponse{Event: event}, nil
}

func (s *server) GetEventById(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event, ok := events[req.GetEvent().GetId()]
    if !ok {
        return nil, fmt.Errorf("event not found")
    }
    return &pb.EventResponse{Event: event}, nil
}

func (s *server) UpdateEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    event := req.GetEvent()
    if _, ok := events[event.GetId()]; !ok {
        return nil, fmt.Errorf("event not found")
    }
    events[event.GetId()] = event
    return &pb.EventResponse{Event: event}, nil
}

func (s *server) DeleteEvent(ctx context.Context, req *pb.EventRequest) (*pb.EventResponse, error) {
    eventID := req.GetEvent().GetId()
    if _, ok := events[eventID]; !ok {
        return nil, fmt.Errorf("event not found")
    }
    delete(events, eventID)
    return &pb.EventResponse{}, nil
}

func (s *server) ListEvents(ctx context.Context, req *pb.EventRequest) (*pb.EventListResponse, error) {
    var eventList []*pb.Event
    for _, event := range events {
        eventList = append(eventList, event)
    }
    return &pb.EventListResponse{Events: eventList}, nil
}

func main() {
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    s := grpc.NewServer()
    pb.RegisterEventServiceServer(s, &server{})
    log.Println("Starting server on :50051")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
