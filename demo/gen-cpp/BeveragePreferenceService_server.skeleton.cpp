
#include "BeveragePreferenceService.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using namespace  ::vending_machine;

class BeveragePreferenceServiceHandler : virtual public BeveragePreferenceServiceIf {
 public:
  BeveragePreferenceServiceHandler() {
    // Your initialization goes here
  }

  void PlaceOrder(std::string& _return, const int64_t city) {
    // Your implementation goes here
    printf("PlaceOrder\n");
  }

};

int main(int argc, char **argv) {
  int port = 9090;
  ::std::shared_ptr<BeveragePreferenceServiceHandler> handler(new BeveragePreferenceServiceHandler());
  ::std::shared_ptr<TProcessor> processor(new BeveragePreferenceServiceProcessor(handler));
  ::std::shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
  ::std::shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
  ::std::shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

  TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
  return 0;
}
