local vending_machine_ttype= require 'vending_machine_ttypes'
local Thrift = require 'Thrift'
local TType = Thrift.TType
local TMessageType = Thrift.TMessageType
local __TObject = Thrift.__TObject
local TApplicationException = Thrift.TApplicationException
local __TClient = Thrift.__TClient
local __TProcessor = Thrift.__TProcessor
local ttype = Thrift.ttype
local ttable_size = Thrift.ttable_size
local TException = Thrift.TException


local BeveragePreferenceServiceClient = __TObject.new(__TClient, {
  __type = 'BeveragePreferenceServiceClient'
})

local PlaceOrder_args=__TObject:new{
	city
}
function BeveragePreferenceServiceClient:PlaceOrder(city)
  self:send_PlaceOrder(city)
  return self:recv_PlaceOrder(city)
end

function BeveragePreferenceServiceClient:send_PlaceOrder(city)
  self.oprot:writeMessageBegin('PlaceOrder', TMessageType.CALL, self._seqid)
  local args = PlaceOrder_args:new{}
  args.city = city
  args:write(self.oprot)
  self.oprot:writeMessageEnd()
  self.oprot.trans:flush()
end

function BeveragePreferenceServiceClient:recv_PlaceOrder(city)
  local fname, mtype, rseqid = self.iprot:readMessageBegin()
  if mtype == TMessageType.EXCEPTION then
    local x = TApplicationException:new{}
    x:read(self.iprot)
    self.iprot:readMessageEnd()
    error(x)
  end
  local result = PlaceOrder_result:new{}
  result:read(self.iprot)
  self.iprot:readMessageEnd()
  if result.success ~= nil then
    return result.success
  elseif result.se then
    error(result.se)
  end
  error(TApplicationException:new{errorCode = TApplicationException.MISSING_RESULT})
end
local BeveragePreferenceServiceIface = __TObject:new{
  __type = 'BeveragePreferenceServiceIface'
}


BeveragePreferenceServiceProcessor = __TObject.new(__TProcessor
, {
 __type = 'BeveragePreferenceServiceProcessor'
})

function BeveragePreferenceServiceProcessor:process(iprot, oprot, server_ctx)
  local name, mtype, seqid = iprot:readMessageBegin()
  local func_name = 'process_' .. name
  if not self[func_name] or ttype(self[func_name]) ~= 'function' then
    if oprot ~= nil then
      iprot:skip(TType.STRUCT)
      iprot:readMessageEnd()
      x = TApplicationException:new{
        errorCode = TApplicationException.UNKNOWN_METHOD
      }
      oprot:writeMessageBegin(name, TMessageType.EXCEPTION, seqid)
      x:write(oprot)
      oprot:writeMessageEnd()
      oprot.trans:flush()
    end
    return false, 'Unknown function '..name
  else
    return self[func_name](self, seqid, iprot, oprot, server_ctx)
  end
end

function BeveragePreferenceServiceProcessor:process_PlaceOrder(seqid, iprot, oprot, server_ctx)
  local args = PlaceOrder_args:new{}
  local reply_type = TMessageType.REPLY
  args:read(iprot)
  iprot:readMessageEnd()
  local result = PlaceOrder_result:new{}
  local status, res = pcall(self.handler.PlaceOrder, self.handler, args.city)
  if not status then
    reply_type = TMessageType.EXCEPTION
    result = TApplicationException:new{message = res}
  elseif ttype(res) == 'ServiceException' then
    result.se = res
  else
    result.success = res
  end
  oprot:writeMessageBegin('PlaceOrder', reply_type, seqid)
  result:write(oprot)
  oprot:writeMessageEnd()
  oprot.trans:flush()
  return status, res
end

-- HELPER FUNCTIONS AND STRUCTURES

function PlaceOrder_args:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 1 then
      if ftype == TType.I64 then
        self.city = iprot:readI64()
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function PlaceOrder_args:write(oprot)
  oprot:writeStructBegin('PlaceOrder_args')
  if self.city ~= nil then
    oprot:writeFieldBegin('city', TType.I64, 1)
    oprot:writeI64(self.city)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end

PlaceOrder_result = __TObject:new{
  success,
  se
}

function PlaceOrder_result:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 0 then
      if ftype == TType.STRING then
        self.success = iprot:readString()
      else
        iprot:skip(ftype)
      end
    elseif fid == 1 then
      if ftype == TType.STRUCT then
        self.se = ServiceException:new{}
        self.se:read(iprot)
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function PlaceOrder_result:write(oprot)
  oprot:writeStructBegin('PlaceOrder_result')
  if self.success ~= nil then
    oprot:writeFieldBegin('success', TType.STRING, 0)
    oprot:writeString(self.success)
    oprot:writeFieldEnd()
  end
  if self.se ~= nil then
    oprot:writeFieldBegin('se', TType.STRUCT, 1)
    self.se:write(oprot)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end