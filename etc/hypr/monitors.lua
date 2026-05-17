-- monitor configuration
-- monitor=desc:[DESCRIPTION],resolution@refresh-rate,position,scale,transform,rotation

function GetHostname()
    local f = io.popen ("cat /etc/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname =string.gsub(hostname, "\n$", "")
    return hostname
end

local hostname = GetHostname()
-- GARCHOMP
if hostname == "garchomp" then
  -- vertical monitor
  hl.monitor({output = "desc:Hewlett Packard HP Z23i 3CQ4513C16", mode = "1920x1080@60", position = "-1080x0", scale = 1,transform = 1 })
  -- main monitor
  hl.monitor({output = "desc:AOC 27G2G4 GYGLAHA242374", mode = "1920x1080@144", position = "0x0", scale = 1 })
  -- lock workspaces to specific monitors
  hl.workspace_rule({ workspace = "1", monitor = "desc:AOC 27G2G4 GYGLAHA242374", default = true })
  hl.workspace_rule({ workspace = "6", monitor = "desc:AOC 27G2G4 GYGLAHA242374", default = true })
  hl.workspace_rule({ workspace = "8", monitor = "desc:Hewlett Packard HP Z23i 3CQ4513C16", default = true })
  hl.workspace_rule({ workspace = "9", monitor = "desc:Hewlett Packard HP Z23i 3CQ4513C16", default = true })
  hl.workspace_rule({ workspace = "10", monitor = "desc:Hewlett Packard HP Z23i 3CQ4513C16", default = true })
end


if hostname == "conkeldurr" then
  hl.monitor({output = "desc:AU Optronics 0x243D", mode = "1920x1080@60", position = "0x0", scale = 1.5 })
end

if hostname == "serperior" then
  hl.monitor({output = "desc:LG Display 0x075C", mode = "2560x1600@120", position = "0x0", scale = 1.60 })
end

if hostname == "drampa" then
  hl.monitor({output = "desc:Hewlett Packard HP 22cw 6CM5320GZ2@60", mode = "1920x1080", position = "0x0", scale = 1 })
end
