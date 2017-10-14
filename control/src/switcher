os.loadAPI("async")

CHANNEL_ANNOUNCE = 1000
CHANNEL_REPLY = 1001
MAX_DISTANCE = 5

local modem = peripheral.wrap("bottom")
modem.open(CHANNEL_REPLY)

function red(event)
  if rs.getInput("left") then
    modem.transmit(CHANNEL_ANNOUNCE, CHANNEL_REPLY, "ANNOUNCE")
  end
end

function switch(event,side,senderCh,replyChannel,message,distance)
  print(message)
  if distance < MAX_DISTANCE then
    if message == "left" then
      redstone.setOutput("right", true)
    end
    if message == "right" then
      redstone.setOutput("right", false)
    end
  end
end

async.addEventListener("redstone", red)
async.addEventListener("modem_message", switch)

async.init()
