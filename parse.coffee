#!/usr/bin/env coffee

import fs from 'fs'
import readline from 'readline'
import {thisdir} from '@rmw/thisfile'
import path from 'path'

parse_log = (log)=>
  for await line from readline.createInterface({
    input: fs.createReadStream(log)
    crlfDelay: Infinity
  })
    if line.length <= 2
      continue
    line = JSON.parse(line)
    name = line.name
    name_exist = false
    exist = new Set()
    if line.files
      for file from line.files
        for fp from file.path
          if fp.indexOf('(比特彗星)') > 0
            continue
          if exist.has fp
            continue
          exist.add fp
          if not name_exist
            if fp.indexOf(name) >= 0
              name_exist = true

    if not name_exist
       console.log name

    if exist.size
      console.log Array.from(exist).join('/')



do =>
  filename = process.argv[3..]
  if not filename.length
    filename = ['log/example.log']
  dir = thisdir(`import.meta`)
  for f from filename
    parse_log path.join(dir, f)

