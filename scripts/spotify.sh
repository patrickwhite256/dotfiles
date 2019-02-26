#!/bin/bash
osascript << END
tell application "Spotify"
        if ((player state as string) is equal to "playing") then
                set currentArtist to artist of current track as string
                set currentTrack to name of current track as string
                return currentArtist & " - " & currentTrack
        end if
end tell
END
