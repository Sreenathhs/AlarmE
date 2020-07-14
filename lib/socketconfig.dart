import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

class SocketConfig {
  static SocketIO socketIO;
  static initiate(){
    socketIO = SocketIOManager().createSocketIO("http://a73f91388943.ngrok.io", "/test", query: "userId=21031", socketStatusCallback: _socketStatus);

    //call init socket before doing anything
    socketIO.init();

    //subscribe event
    socketIO.subscribe("socket_info", _onSocketInfo);

    //connect socket
    socketIO.connect();

  }

  static _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
  }

  static _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
}