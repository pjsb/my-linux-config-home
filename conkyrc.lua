local common = {}

local f = io.popen ("/bin/hostname")
local hostname = f:read("*a") or ""
f:close()
hostname = string.gsub(hostname, "\n$", "")

if "D-SLS-PC-L01-JP" == hostname then
  common.lan = "enp3s0"
  common.mounts = {"/", "/tmp", "/home", "nbcache"}
  common.cputemp = "'Physical id 0'"
elseif "pv01.home"  == hostname then
  common.lan = "wlp9s0"
  common.mounts = {"/", "/tmp", "/home", "/media/local", "/media/data"}
  common.cputemp = "'Physical id 0'"
elseif "pv02.home"  == hostname then
  common.lan = "wlp0s29f7u1"
  common.mounts = {"/", "/tmp", "/home"}
  common.cputemp = "coretemp-isa-"
end

function common.dirGraphs()
  local tplString = ""
  for i, mount in ipairs(common.mounts) do
    tplString = tplString .. string.format([[${color white}%s\
${alignr} ${fs_used %s} / ${fs_size %s}
${fs_bar 8 %s}
]], mount,mount,mount,mount)
  end
  return tplString
end

return common

