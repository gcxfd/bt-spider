#!/usr/bin/env coffee

import fs from 'fs/promises'
import path from 'path'
import Heap from 'heap'

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
  count = new Map()

  count_txt = (f)=>
    if not f.endsWith('.txt')
      return

    txt = await fs.readFile(f, 'utf8')

    for i from take1_7(txt)
      count.set(
        i
        (count.get(i) or 0)+i.length
      )

  for await f from walk('txt')
    console.log f
    await count_txt(f)

  heap = new Heap(cmp)
  for i in [0..254]
    heap.push [0,0]

  small = 0

  sort = []
  for i from count.entries()
    v = i[1]
    if v > small
      small = heap.pushpop(i)[1]

  heap = heap.toArray()
  heap.sort cmp
  n = 0
  for i from heap
    console.log ++n, i



