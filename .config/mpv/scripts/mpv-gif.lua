-- Create animated GIFs with mpv
-- Requires ffmpeg.
-- Adapted from http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
-- Usage: "g" to set start frame, "G" to set end frame, "Ctrl+g" to create.
local msg = require 'mp.msg'
local utils = require 'mp.utils'

-- options
require 'mp.options'
local options = {
  fps = 15,
  width = -1,
  height = -1,
  extension = "gif",
  outputDirectory = "~/usr/pics/mpv/gifs"
}
read_options(options, "gifgen")

-- expand given path (i.e. ~/, ~~/, …)
res, err = mp.command_native({"expand-path", options.outputDirectory})
options.outputDirectory = res

-- Set this to the filters to pass into ffmpeg's -vf option.
-- filters="fps=24,scale=320:-1:flags=lanczos"
filters = options.fps < 0 and "" or string.format("fps=%d,", options.fps)
filters = filters .. string.format(
  "scale=%d:%d:flags=lanczos", 
  --options.fps,
  options.width, options.height
                                  )

start_time = -1
end_time = -1
palette="/tmp/palette.png"

function make_gif_with_subtitles()
  make_gif_internal(true)
end

function make_gif()
  make_gif_internal(false)
end

function get_path()
  -- TODO: improve detection of file paths (relative, windows, …)
  return utils.join_path(
    mp.get_property("working-directory", ""),
    mp.get_property("path")
  )
end

function get_gifname()
  -- then, make the gif
  local filename = mp.get_property("filename/no-ext")
  local file_path = options.outputDirectory .. "/" .. filename

  -- increment filename
  for i=0,999 do
    local fn = string.format('%s_%03d.%s',file_path,i, options.extension)
    if not file_exists(fn) then
      gifname = fn
      break
    end
  end

  if not gifname then
    msg.warning("No available filename")
    mp.osd_message('No available filenames!')
    return nil
  end

  return gifname
end

function log_command_result(res, val, err)
  if not (res and (val == nil or val["status"] == 0)) then
    if val["stderr"] then
      if mp.get_property("options/terminal") == "no" then
        file = io.open(string.format("/tmp/mpv-gif-ffmpeg.%s.log", os.time()), "w")
        file:write(string.format("ffmpeg error %d:\n%s", val["status"], val["stderr"]))
        file:close()
      else
        msg.error(val["stderr"])
      end
    end

    msg.error("GIF generation was unsuccessful")
    mp.osd_message("error creating GIF")
    return -1
  end

  return 0
end

function get_tracks()
  -- retrieve information about currently selected tracks
  local tracks, err = utils.parse_json(mp.get_property("track-list"))
  if tracks == nil then
    msg.warning("Couldn't parse track-list")
    return
  end

  local video = nil
  local has_sub = false
  local sub = nil

  for _, track in ipairs(tracks) do
    has_sub = has_sub or track["type"] == "sub"

    if track["selected"] == true then
      if track["type"] == "video" then
        video = {id=track["id"]}
      elseif track["type"] == "sub" then
        sub = {id=track["id"], codec=track["codec"]}
      end

    end
  end

  return video, sub, has_sub
end


function make_gif_internal(burn_subtitles)
  local start_time_l = start_time
  local end_time_l = end_time
  if start_time_l == -1 or end_time_l == -1 or start_time_l >= end_time_l then
    mp.osd_message("Invalid start/end time.")
    return
  end

  local sel_video, sel_sub, has_sub = get_tracks()

  if sel_video == nil then
    mp.osd_message("GIF abort: no video")
    msg.info("No video selected")
    return
  end


  msg.info("Creating GIF" .. (burn_subtitles and " (with subtitles)" or ""))
  mp.osd_message("Creating GIF" .. (burn_subtitles and " (with subtitles)" or ""))

  local pathname = get_path()

  subtitle_filter = ""
  -- add subtitles only for final rendering as it slows down significantly
  if burn_subtitles and has_sub then
    -- TODO: implement usage of different subtitle formats (i.e. bitmap ones, …)
    sid = (sel_sub == nil and 0 or sel_sub["id"] - 1)  -- mpv starts counting subtitles with one
    subtitle_filter = string.format(",subtitles='%s':si=%d", ffmpeg_esc(pathname), sid)
  elseif burn_subtitles then
    msg.info("There are no subtitle tracks")
    mp.osd_message("GIF: ignoring subtitle request")
  end


  local position = start_time_l
  local duration = end_time_l - start_time_l

  local gifname = get_gifname()
  if gifname == nil then
    return
  end

  -- set arguments
  v_track = string.format("[0:v:%d] ", sel_video["id"] - 1)
  local filter_pal = v_track .. filters .. ",palettegen=stats_mode=diff"
  local args_palette = {
    -- "flatpak-spawn", "--host",
    "ffmpeg", "-v", "warning", 
    "-ss", tostring(position), "-t", tostring(duration),
    "-i", pathname, 
    "-vf", filter_pal,
    "-y", palette
  }

  local filter_gif = v_track .. filters .. subtitle_filter .. " [x]; "
  filter_gif = filter_gif .. "[x][1:v] paletteuse=dither=bayer:bayer_scale=3:diff_mode=rectangle"
  local args_gif = {
    -- "flatpak-spawn", "--host",
    "ffmpeg", "-v", "warning",
    "-ss", tostring(position), "-t", tostring(duration),  -- define which part to use
    "-copyts",  -- otherwise ss can't be reused
    "-i", pathname, "-i", palette,  -- open files
    "-an",  -- remove audio
    "-ss", tostring(position),  -- required for burning subtitles
    "-lavfi", filter_gif,
    "-y", gifname  -- output
  }

  -- first, create the palette
  mp.command_native_async({ 
      name="subprocess", args=args_palette, capture_stdout=true, capture_stderr=true 
                          }, function(res, val, err)
      if log_command_result(res, val, err) ~= 0 then
        return
      end

      msg.debug("Generated palette")

      mp.command_native_async({ 
          name="subprocess", args=args_gif, capture_stdout=true, capture_stderr=true 
                              }, function(res, val, err)
          if log_command_result(res, val, err) ~= 0 then
            return
          end

          msg.info(string.format("GIF created - %s", gifname))
          mp.osd_message(string.format("GIF created - %s", gifname), 2)
      end)
  end)
end

function set_gif_start()
  start_time = mp.get_property_number("time-pos", -1)
  mp.osd_message("GIF Start: " .. start_time)
end

function set_gif_end()
  end_time = mp.get_property_number("time-pos", -1)
  mp.osd_message("GIF End: " .. end_time)
end

function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

function get_containing_path(str,sep)
  sep=sep or package.config:sub(1,1)
  return str:match("(.*"..sep..")")
end

function ffmpeg_esc(s)
  -- escape string to be used in ffmpeg arguments (i.e. filenames in filter)
  s = string.gsub(s, "\\", "\\\\")
  s = string.gsub(s, ":", "\\:")
  s = string.gsub(s, "'", "\\'")
  return s
end

mp.add_key_binding("Ctrl+g", "set_gif_start", set_gif_start)
mp.add_key_binding("Ctrl+G", "set_gif_end", set_gif_end)
mp.add_key_binding("Ctrl+Alt+g", "make_gif", make_gif)
mp.add_key_binding("Ctrl+Alt+G", "make_gif_with_subtitles", make_gif_with_subtitles)
