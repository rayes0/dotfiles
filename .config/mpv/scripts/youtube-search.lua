-- Search youtube with mpv

local mp = require "mp"
package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"})..package.path
local uin = require "user-input-module"

function search_youtube(query, err)
  if not query then return end
  mp.commandv("loadfile", "ytdl://ytsearch30:" .. query, "replace")
  mp.commandv("script-message", "playlist-view-open")
end

mp.add_key_binding("/", "search_youtube", function ()
                     uin.get_user_input(search_youtube, {
                                          source = "Search Youtube",
                                          request_text = "",
                                          replace = true },
                                        "search_youtube")
end)
