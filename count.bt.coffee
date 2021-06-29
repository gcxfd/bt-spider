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
    hash = line.infohash
    [name, count] = bt.get(hash) or ['',0]
    name = line.name
    bt.set(hash, [name,count+1])
  bt = Array.from(bt.entries())
  bt.sort (a,b)=>
    a[1][1]-b[1][1]
  for line from bt[..100]
    console.log line[0],line[1].join(' ')



do =>
  filename = process.argv[3..]
  if not filename.length
    filename = ['log/example.log']
  for f from filename
    parse_log f

