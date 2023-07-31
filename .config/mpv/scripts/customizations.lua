-- -- Personal functions for mpv

utils = require "mp.utils"

local function msg(s)
  mp.osd_message(s)
end

local function prt(s)
  mp.msg.info(s)
  msg(s)
end

-- btfs torrents
local mountdir = '/home/rayes/var/mpv-btfs'
local datadir = '/home/rayes/var/mpv-btfs'

local btfs_mounted = {}
  
local function play_torrent()
  local url = mp.get_property("stream-open-filename")
  if not url:match('^magnet:%?xt=urn:btih:*.') or url:gsub('[?#].*', '', 1):match('/([^/]+%.torrent)$') then
    return
  end

  local mount_dir = utils.join_path(mountdir, mp.get_time())
  mp.commandv("run", "mkdir", "-p", mount_dir)

  local btfs_cmd = {"run", "flatpak-spawn", "--host",
                    "btfs", "--max-upload-rate=500", "--keep",
                    "--data-directory="..datadir, url, mount_dir}
  mp.command_native(btfs_cmd)

  -- prt("waiting for video")
  local screenx, screeny, aspect = mp.get_osd_size()
  mp.set_osd_ass(screenx, screeny, "waiting {\\an9}●")
  while utils.readdir(mount_dir)[1] == nil do
    os.execute("sleep 1")
  end
  mp.set_osd_ass(screenx, screeny, "")

  table.insert(btfs_mounted, mount_dir)
  mp.set_property("stream-open-filename", mount_dir)
end

local function torrent_cleanup()
  for _, mount_dir in pairs(btfs_mounted) do
    prt("unmounting " .. mount_dir)
    mp.command_native({"run", "flatpak-spawn", "--host",
                       "fusermount", "-u", mount_dir})
    os.remove(mount_dir)
  end
end

mp.add_hook("on_load", 50, play_torrent)
mp.register_event("shutdown", torrent_cleanup)


-- fast forward rather than seeking
-- local function fastfor


-- save current session
-- local function save_session()
--   local length = mp.get_property_number('playlist-count', 0)
--   if length == 0 then return end

--   local savepath = utils.join_path('/home/rayes/.config/mpv/saved', os.time().."-size_"..length.."-playlist.m3u")
--   local file = io.open(savepath, 'w')
--   if not file then
--     msg('failed to write to session file')
--   else
--     local i=0
--     while i < length do
--       local pwd = mp.get_property("working-directory")
--       local filename = mp.get_property('playlist/'..i..'/filename')
--       local fullpath = filename
--       if not filename:match("^%a%a+:%/%/") then
--         fullpath = utils.join_path(pwd, filename)
--       end
--       file:write(fullpath, "n")
--       i=i+1
--     end
--     prt("playlist written to: "..savepath)
--     file:close()
--   end
-- end

-- mp.add_key_binding("alt+s", save_session)


-- -- webp gif
-- local filters = string.format("fps=%s,zscale='trunc(ih*dar/2)*2:trunc(ih/2)*2':f=spline36,setsar=1/1,zscale=%s:-1:f=spline36", fps, options.rez)
-- local outdir = "~/usr/pics/mpv/gifs"

-- local start_time = nil
-- local end_time = nil

-- function 
