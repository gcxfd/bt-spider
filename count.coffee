#!/usr/bin/env coffee

import fs from 'fs/promises'
import path from 'path'
import streamcount from 'streamcount'

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
      yield* walk(entry)
    else if d.isFile()
      yield entry

cmp = (a,b)=>
  a[1]-b[1]

do =>
  count = streamcount.createViewsCounter(254)

  count_txt = (f)=>
    if not f.endsWith('.txt')
      return

    txt = await fs.readFile(f, 'utf8')

    for i from take1_7(txt)
      n = i.length
      while n--
        count.increment(i)

  for await f from walk('txt')
    console.log f
    await count_txt(f)


  n = 0
  for i from count.getTopK()
    console.log ++n, i



