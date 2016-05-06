#! /usr/bin/env tclsh
#
# This file implements a basic bot for the AI Game.
#
# The structure of
# this file is trivial. At the bottom you can find the main loop,
# which simply evaluates the input as tcl code. Right above the main
# loop are the implementation of the place_disc, settings, action and
# update command. These implement the basic protocol.
#
# At the top you will find a few variables that will be set by the
# protocol commands. These can be used to implement your strategy.
# Each action request from the server will trigger the move command.


set settings [dict create]
set field    [dict create]
set round    0


# My Algorithm:
proc move {t} {
    global settings fields

    place_disc 0;               # Implement your fancy algorithm here
}



# Implemention of the game protocol:
proc place_disc {i} {
    puts "place_disc $i"
}

proc settings {key value} {
    global settings

    if {$key == "player_names"} {
        set value [split $value ,]
    }

    dict set settings $key $value
}

proc update {type key value} {
    global round field

    if {$type == "game"} {
        set $key $value;        # Ugly hack, but works
    } else {
        return -code error "update :: Got invalid type '$type'"
    }
}

proc action {type t} {
    if {$type == "move"} {
        move $t
    } else {
        return -code error "action :: Got invalid type '$type'"
    }
}



# Start main loop (just evaluates input):
while {[gets stdin line] >= 0} {
    # Eval sees ';' as 'end of statement', so we have to eliminate them.
    if {[string first "update game field" $line] == 0} {
        regsub -all ";" $line ":" line
    }

    eval $line
}
