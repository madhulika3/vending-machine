--
-- Autogenerated by Thrift
--
-- DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
-- @generated
--

local vending_machine_ttype = require
local Thrift = require
local TType = Thrift.TType
local TMessageType = Thrift.TMessageType
local __TObject = Thrift.__TObject
local TApplicationException = Thrift.TApplicationException
local __TClient = Thrift.__TClient
local __TProcessor = Thrift.__TProcessor
local ttype = Thrift. ttype
local ttable_size = Thrift.ttable_size
local TException = Thrift.Texception

local WeatherServiceClient = __TObject.new(__TClient, {
  __type = 'WeatherServiceClient'
})

function WeatherServiceClient:GetWeather(city)
  self:send_GetWeather(city)
  return self:recv_GetWeather(city)
end

function WeatherServiceClient:send_GetWeather(city)
  self.oprot:writeMessageBegin('GetWeather', TMessageType.CALL, self._seqid)
  local args = GetWeather_args:new{}
  args.city = city
  args:write(self.oprot)
  self.oprot:writeMessageEnd()
  self.oprot.trans:flush()
end

function WeatherServiceClient:recv_GetWeather(city)
  local fname, mtype, rseqid = self.iprot:readMessageBegin()
  if mtype == TMessageType.EXCEPTION then
    local x = TApplicationException:new{}
    x:read(self.iprot)
    self.iprot:readMessageEnd()
    error(x)
  end
  local result = GetWeather_result:new{}
  result:read(self.iprot)
  self.iprot:readMessageEnd()
  if result.success ~= nil then
    return result.success
  end
  error(TApplicationException:new{errorCode = TApplicationException.MISSING_RESULT})
end
WeatherServiceIface = __TObject:new{
  __type = 'WeatherServiceIface'
}


WeatherServiceProcessor = __TObject.new(__TProcessor
, {
 __type = 'WeatherServiceProcessor'
})

function WeatherServiceProcessor:process(iprot, oprot, server_ctx)
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

function WeatherServiceProcessor:process_GetWeather(seqid, iprot, oprot, server_ctx)
  local args = GetWeather_args:new{}
  local reply_type = TMessageType.REPLY
  args:read(iprot)
  iprot:readMessageEnd()
  local result = GetWeather_result:new{}
  local status, res = pcall(self.handler.GetWeather, self.handler, args.city)
  if not status then
    reply_type = TMessageType.EXCEPTION
    result = TApplicationException:new{message = res}
  else
    result.success = res
  end
  oprot:writeMessageBegin('GetWeather', reply_type, seqid)
  result:write(oprot)
  oprot:writeMessageEnd()
  oprot.trans:flush()
  return status, res
end

-- HELPER FUNCTIONS AND STRUCTURES

GetWeather_args = __TObject:new{
  city
}

function GetWeather_args:read(iprot)
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

function GetWeather_args:write(oprot)
  oprot:writeStructBegin('GetWeather_args')
  if self.city ~= nil then
    oprot:writeFieldBegin('city', TType.I64, 1)
    oprot:writeI64(self.city)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end

GetWeather_result = __TObject:new{
  success
}

function GetWeather_result:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 0 then
      if ftype == TType.I32 then
        self.success = iprot:readI32()
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

function GetWeather_result:write(oprot)
  oprot:writeStructBegin('GetWeather_result')
  if self.success ~= nil then
    oprot:writeFieldBegin('success', TType.I32, 0)
    oprot:writeI32(self.success)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end
