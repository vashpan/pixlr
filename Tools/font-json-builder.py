#!/usr/bin/python

# This is a very rough script to generate font JSONs
# Basically you need to change those parameters every time you generate a new font :)
# DO NOT CONSIDER THIS AS A FINAL TOOL!
#
# Please :)
#

import json

characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+[];'\\,./{}:\"|<>?`~"

# settings
glyph_size = 8
max_glyphs_in_line = 15
output_filename = 'press-start.json'

# font info
font_info = {
    'size': 8,
    'spacing': 0,
    'lineHeight': glyph_size
}

# glyphs
x = 0
y = 0
chars_in_line = 0

glyphs = []
for c in characters:
    glyph = { 
        'char': c,
        'x': x,
        'y': y,
        'w': 8,
        'h': 8
    }
    glyphs.append(glyph)

    chars_in_line += 1
    x += glyph_size
    if chars_in_line == max_glyphs_in_line:
        chars_in_line = 0
        x = 0
        y += glyph_size

# dump json
font_data = {
    'fontInfo': font_info,
    'glyphs': glyphs 
}

with open(output_filename, 'w') as outfile:
    json.dump(font_data, outfile, indent=4)
    print('Yeah! Font file generated: ' + output_filename)
