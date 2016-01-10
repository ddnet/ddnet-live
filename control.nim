import irc, strutils, secret

const
  forbiddenCommands = ["exec", "quit", "exit", "disconnect"]
  allowedNicks = ["onionly_me", "ryozukii", "deen_ddnet", "ddnetlive",
    "aoeteeworlds", "learath2"]

var
  client = newIrc("irc.twitch.tv", nick = "ddnetlive",
    serverPass = serverPass, joinChans = @["#ddnetlive"])
  fifo = open("input.fifo", fmWrite)

proc handle(nick, cmd: string) =
  if nick notin allowedNicks:
    return

  for f in forbiddenCommands:
    if cmd.contains(f):
      return

  echo nick, ": ", cmd
  stdout.flushFile()

  fifo.write(cmd)
  fifo.write("\n")
  fifo.flushFile()

client.connect()
var event: TIrcEvent

while true:
  if client.poll(event):
    case event.typ
    of EvConnected:
      discard
    of EvDisconnected, EvTimeout:
      client.reconnect()
    of EvMsg:
      case event.cmd
      of MPrivMsg:
        handle(event.nick, event.params[^1])
      else:
        discard
