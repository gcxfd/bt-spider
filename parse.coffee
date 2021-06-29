#!/usr/bin/env coffee

import fs from 'fs'
import {writeFile} from 'fs/promises'
import readline from 'readline'
import {thisdir} from '@rmw/thisfile'
import path from 'path'

DIR = thisdir(`import.meta`)

parse_log = (log)=>
  exist_bt = new Set()
  for await line from readline.createInterface({
    input: fs.createReadStream(log)
    crlfDelay: Infinity
  })
    if line.length <= 2
      continue
    line = JSON.parse(line)
    hash = Buffer.from(line.infohash,'hex').toString('binary')
    if exist_bt.has hash
      continue
    exist_bt.add hash
    name = line.name
    name_exist = false
    pli = []
    exist = new Set()
    if line.files
      for file from line.files
        t = []
        for fp from file.path
          if fp.indexOf('(比特彗星)') > 0
            continue
          if exist.has fp
            continue
          exist.add fp
          t.push fp
          if not name_exist
            if fp.indexOf(name) >= 0
              name_exist = true
        if t.length
          pli.push t.join '/'

    if not name_exist
       pli.unshift name

    await writeFile(
      path.join(DIR,"txt/#{exist_bt.size}.txt")
      pli.join("\n")
    )
    console.log pli




do =>
  filename = process.argv[3..]
  if not filename.length
    filename = ['log/example.log']
  for f from filename
    parse_log f

