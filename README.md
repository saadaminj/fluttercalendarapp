# calendarapp

A new Flutter project (using BloC pattern) with. Go lang as backend server (using microservices architecture).

It has following features implemented both in frontend and backend:
- Login/ Logout
- Signup with validation
- JWT Authentication (with refresh token handler on token expiry)
- Create/ Delete/ Update Reminder with validation
- Fetch list of reminders based on users

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)


### HOW TO RUN:

- Install golang in your local pc and set your gopath and goroot variables

- Install relevant/ missing packages first.
"go get -u google.golang.org/grpc
go get -u github.com/golang/protobuf/proto"


- Run "go mod init" command, this project was init under my personal directory, you have to run go mod init in your own pc depends on your directory structure. 

- RUN "dart pub get" to install dart dependencies

- After installing all the dependencies, inside calendarapp run this command "go run go/main.go". This command will run the go lang server.

- once go lang server is running, run the flutter app. 

### HOW TO GENERATE PROTO FILES:

export PATH=$PATH:$(go env GOPATH)/bin

To generate go files in protos directory
- protoc --go_out=. --go-grpc_out=. events.proto


export PATH="$PATH":"$HOME/.pub-cache/bin"

To generate dart files
- protoc --dart_out=grpc:./ -Iprotos protos/events.proto

or 
- protoc --dart_out=grpc:lib/src/generated -Igo go/protos/events.proto


List down processes using port 50051:
- lsof -i :50051


### Run & stop the database server

- brew services start mysql
- brew services stop mysql

to go to mysql shell
-- mysql -u root -p



For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
