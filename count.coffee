#!/usr/bin/env coffee

import fs from 'fs/promises'
import path from 'path'

take = (s, n)->
  begin = 0
  end = s.length - n
  while begin <= end
    yield s[begin...begin+n]
    ++begin

take1_7 = (s)->
  n = 0
  while ++n < 8
    for i from take(s,n)
      yield i



walk = (dir)->
  for await d from await fs.opendir(dir)
    entry = path.join(dir, d.name)
    if d.isDirectory()
      `yield* walk(entry)`
    else if d.isFile()
      yield entry

cmp = (b,a)=>
  a[1]-b[1]

do =>
  count = new Map()

  count_txt = (f)=>
    txt = await fs.readFile(f, 'utf8')

    for i from take1_7(txt)
      n = i.length/7
      if Math.random() <= n
        count.set(
          i
          (count.get(i) or 0)+1
        )


  file_count = 0
  for dir in [
    '/Users/z/git/bt-spider/txt'
    '/Users/z/git/bt-spider/data/txt'
  ]
    for await f from walk(dir)
      if not f.endsWith('.txt')
        continue
      ++ file_count
      # data/txt/pansci.asia
      console.log "cat #{f} >> 1.txt"
      continue
      if file_count  % 1000 == 999
        for [k,v] from count.entries()
          if v < 10
            count.delete(k)
          else
            count.set(k,v-10)
      await count_txt(f)

  return
  li = Array.from count.entries()
  li.sort cmp

  for i, n in li[..65792]
    console.log n, i



