#!/usr/bin/env coffee

import fs from 'fs'
import {writeFile} from 'fs/promises'
import readline from 'readline'
import {thisdir} from '@rmw/thisfile'
import path from 'path'

DIR = thisdir(`import.meta`)

parse_log = (log)=>
  bt = new Map()
  for await line from readline.createInterface({
    input: fs.createReadStream(log)
    crlfDelay: Infinity
  })
    if line.length <= 2
      continue
    line = JSON.parse(line)

    if not line.files
      continue

    n = 0
    for i from line.files
      n += i.length

    if n < 1024*1024*100
      continue

    hash = line.infohash
    [name, count] = bt.get(hash) or ['',0]
    name = line.name
    bt.set(hash, [name,count+1])
  bt = Array.from(bt.entries())
  bt.sort (b,a)=>
    a[1][1]-b[1][1]
  for line, pos in bt[..512]
    console.log pos+1, line[0],line[1].join(' ')



do =>
  filename = process.argv[3..]
  if not filename.length
    filename = ['log/example.log']
  for f from filename
    parse_log f

