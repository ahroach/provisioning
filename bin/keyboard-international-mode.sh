#!/bin/bash

# Most characters are formed by 'accent character' followed by standard character
# For example: ' followed by e = é
#              ` followed by a = à
#              " followed by u = ü
#              ^ followed by o = ô
#              ~ followed by n = ñ
#
# To insert punctuation, press <space> following the accent character.
#
# Special case: AltGr + , = ç
#               AltGr + Shift + , = Ç

setxkbmap us -variant intl

