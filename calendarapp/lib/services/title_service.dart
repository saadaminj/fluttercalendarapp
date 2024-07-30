import 'package:grpc/grpc.dart';
import 'package:calendarapp/chat/helloworld.pbgrpc.dart';

abstract class TitleService {
  Future<String> getTitle();
}

class DummyTitleService extends TitleService {
  @override
  Future<String> getTitle() async {
    // return Future.delayed(const Duration(seconds: 6))
    //     .then((value) => 'The title that took 6 seconds to load lol');
    // String x = '';
    // await http
    //     .get(Uri.parse('http://localhost:8080/hello'))
    //     .then((value) => x = value.body);
    // return Future.value('');

    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = GreeterClient(channel);

    const name = 'saad';

    try {
      var response = await stub.sayHello(HelloRequest(name: name));
      print('Greeter client received: ${response.message}');
      response = await stub.sayHelloAgain(HelloRequest(name: name));
      print('Greeter client received: ${response.message}');
      return response.message;
    } catch (e) {
      print('Caught error: $e');
    }
    await channel.shutdown();
    return '';
  }
}
