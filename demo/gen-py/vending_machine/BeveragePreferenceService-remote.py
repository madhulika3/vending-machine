#!/usr/bin/env python

#  options string: py


import sys
import pprint
if sys.version_info[0] > 2:
    from urllib.parse import urlparse
else:
    from urlparse import urlparse
from thrift.transport import TTransport, TSocket, TSSLSocket, THttpClient
from thrift.protocol.TBinaryProtocol import TBinaryProtocol

from vending_machine import BeveragePreferenceService
from vending_machine.ttypes import *

if len(sys.argv) <= 1 or sys.argv[1] == '--help':
    print('')
    print('Usage: ' + sys.argv[0] + ' [-h host[:port]] [-u url] [-f[ramed]] [-s[sl]] [-novalidate] [-ca_certs certs] [-keyfile keyfile] [-certfile certfile] function [arg1 [arg2...]]')
    print('')
    print('Functions:')
    print('  string PlaceOrder(i64 city)')
    print('')
    sys.exit(0)

pp = pprint.PrettyPrinter(indent=2)
host = 'localhost'
port = 9090
uri = ''
framed = False
ssl = False
validate = True
ca_certs = None
keyfile = None
certfile = None
http = False
argi = 1

if sys.argv[argi] == '-h':
    parts = sys.argv[argi + 1].split(':')
    host = parts[0]
    if len(parts) > 1:
        port = int(parts[1])
    argi += 2

if sys.argv[argi] == '-u':
    url = urlparse(sys.argv[argi + 1])
    parts = url[1].split(':')
    host = parts[0]
    if len(parts) > 1:
        port = int(parts[1])
    else:
        port = 80
    uri = url[2]
    if url[4]:
        uri += '?%s' % url[4]
    http = True
    argi += 2

if sys.argv[argi] == '-f' or sys.argv[argi] == '-framed':
    framed = True
    argi += 1

if sys.argv[argi] == '-s' or sys.argv[argi] == '-ssl':
    ssl = True
    argi += 1

if sys.argv[argi] == '-novalidate':
    validate = False
    argi += 1

if sys.argv[argi] == '-ca_certs':
    ca_certs = sys.argv[argi+1]
    argi += 2

if sys.argv[argi] == '-keyfile':
    keyfile = sys.argv[argi+1]
    argi += 2

if sys.argv[argi] == '-certfile':
    certfile = sys.argv[argi+1]
    argi += 2

cmd = sys.argv[argi]
args = sys.argv[argi + 1:]

if http:
    transport = THttpClient.THttpClient(host, port, uri)
else:
    if ssl:
        socket = TSSLSocket.TSSLSocket(host, port, validate=validate, ca_certs=ca_certs, keyfile=keyfile, certfile=certfile)
    else:
        socket = TSocket.TSocket(host, port)
    if framed:
        transport = TTransport.TFramedTransport(socket)
    else:
        transport = TTransport.TBufferedTransport(socket)
protocol = TBinaryProtocol(transport)
client = BeveragePreferenceService.Client(protocol)
transport.open()

if cmd == 'PlaceOrder':
    if len(args) != 1:
        print('PlaceOrder requires 1 args')
        sys.exit(1)
    pp.pprint(client.PlaceOrder(eval(args[0]),))

else:
    print('Unrecognized method %s' % cmd)
    sys.exit(1)

transport.close()
