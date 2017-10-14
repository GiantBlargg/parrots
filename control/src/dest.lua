
local CHANNEL_ANNOUNCE = 1000
local modem = peripheral.wrap("back")
modem.open(CHANNEL_ANNOUNCE)

local dest=...

local event,side,senderCh,replyCh,message,distance=os.pullEvent("modem_message")
modem.transmit(replyCh,1,dest)
