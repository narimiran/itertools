import algorithm, tables


proc count*(start: SomeNumber): iterator(): SomeNumber =
  ## Infinite iterator, counts from a ``start`` to infinity.
  ##
  ## ``start`` needs to be either int of float.
  ## If you need to have a step different than 1, use ``count(start, step)``.
  runnableExamples:
      let
        fromFive = count(5)
        fromNineNine = count(9.9)
      var
        s1: seq[int] = @[]
        s2: seq[float] = @[]
      for i in 1 .. 4:
        s1.add(fromFive())
        s2.add(fromNineNine())
      doAssert s1 == @[5, 6, 7, 8]
      doAssert s2 == @[9.9, 10.9, 11.9, 12.9]

  var n = start
  result = iterator(): SomeNumber =
    while true:
      yield n
      n += 1


proc count*(start, step: SomeNumber): iterator(): SomeNumber =
  ## Infinite iterator, counts from a ``start`` to infinity with a ``step`` step-size.
  ##
  ## ``start`` and ``step`` need to be of the same type, either int of float.
  ## If your step is 1, you can use ``count(start)``.
  runnableExamples:
      let
        fromFive = count(5, 2)
        fromNine = count(9.5, 1.5)
      var
        s1: seq[int] = @[]
        s2: seq[float] = @[]
      for i in 1 .. 4:
        s1.add(fromFive())
        s2.add(fromNine())
      doAssert s1 == @[5, 7, 9, 11]
      doAssert s2 == @[9.5, 11.0, 12.5, 14.0]

  var n = start
  result = iterator(): SomeNumber =
    while true:
      yield n
      n += step


proc cycle*[T](s: openArray[T]): iterator(): T =
  ## Infinite iterator, cycles through the members of a sequence -- when it
  ## gets to the end of it, it starts again from the beginning.
  runnableExamples:
      let
        a = @[1, 3, 9, 5]
        b = @[2.0, 7.5, 11.3]
        c = @['a', 'x', 'm']
        d = @["me", "myself", "I"]
        c1 = cycle(a)
        c2 = cycle(b)
        c3 = cycle(c)
        c4 = cycle(d)
      var
        s1: seq[int] = @[]
        s2: seq[float] = @[]
        s3: seq[char] = @[]
        s4: seq[string] = @[]
      for i in 1 .. 8:
        s1.add(c1())
        s2.add(c2())
        s3.add(c3())
        s4.add(c4())
      doAssert s1 == @[1, 3, 9, 5, 1, 3, 9, 5]
      doAssert s2 == @[2.0, 7.5, 11.3, 2.0, 7.5, 11.3, 2.0, 7.5]
      doAssert s3 == @['a', 'x', 'm', 'a', 'x', 'm', 'a', 'x' ]
      doAssert s4 == @["me", "myself", "I", "me", "myself", "I", "me", "myself"]

  let s = @s
  var i = 0
  result = iterator(): T {.closure.} =
    while true:
      yield s[i]
      i = (i + 1) mod s.len


proc repeat*[T](x: T, times = 0): iterator (): T =
  ## Infinite iterator which yields an object ``x`` infinite numer of times if
  ## ``times`` is not specified.
  ##
  ## If ``times`` is specified, it runs ``times`` number of times.
  runnableExamples:
      let
        a = 3
        b = 2.7
        c = "Nim"
        d = @[1, 2]
        r1 = repeat(a, 4)
        r2 = repeat(b)
        r3 = repeat(c)
        r4 = repeat(d, 3)
      var
        s1: seq[int] = @[]
        s2: seq[float] = @[]
        s3: seq[string] = @[]
        s4: seq[seq[int]] = @[]
      for x in r1():
        s1.add(x)
      for i in 1 .. 5:
        s2.add(r2())
        s3.add(r3())
      for x in r4():
        s4.add(x)
      doAssert s1 == @[3, 3, 3, 3]
      doAssert s2 == @[2.7, 2.7, 2.7, 2.7, 2.7]
      doAssert s3 == @["Nim", "Nim", "Nim", "Nim", "Nim"]
      doAssert s4 == @[@[1, 2], @[1, 2], @[1, 2]]

  result = iterator(): T =
    if times == 0:
      while true:
        yield x
    else:
      for _ in 1 .. times:
        yield x


iterator accumulate*[T](s: openArray[T], f: proc(a, b: T): T): T =
  ## Iterator which yields accumulated results of binary function ``f``.
  ##
  ## The result of ``f`` must be of the same type as members of ``s``.
  ## The first yielded value is the first member of ``s``.
  runnableExamples:
      let
        a = @[1, 3, 7, 5, 4]
        b = [1.0, 2.5, 6, 4, 5]
      var
        s1: seq[int] = @[]
        s2: seq[float] = @[]
      proc myadd(x, y: int): int = x + y
      proc mymult(x, y: float): float = x * y
      for x in accumulate(a, myadd):
        s1.add(x)
      for x in accumulate(b, mymult):
        s2.add(x)
      doAssert s1 == @[1, 4, 11, 16, 20]
      doAssert s2 == @[1.0, 2.5, 15.0, 60.0, 300.0]

  var total = s[0]
  yield total
  for i in 1 ..< s.len:
    total = f(total, s[i])
    yield total


iterator chain*[T](xs: varargs[seq[T]]): T =
  ## Iterator which yields elements of each passed sequence.
  runnableExamples:
      let
        a = @[1, 5, 4]
        b = @[9, 8, 7]
        c = @[22, 33, 44]
      var
        s1: seq[int] = @[]
        s2: seq[int] = @[]
        s3: seq[int] = @[]
      for x in chain(a):
        s1.add(x)
      for x in chain(b, c):
        s2.add(x)
      for x in chain(c, a, b):
        s3.add(x)
      doAssert s1 == @[1, 5, 4]
      doAssert s2 == @[9, 8, 7, 22, 33, 44]
      doAssert s3 == @[22, 33, 44, 1, 5, 4, 9, 8, 7]

  for arg in xs:
    for x in arg:
      yield x


iterator compress*[T](s: openArray[T], b: openArray[bool]): T =
  ## Iterator which yields only those elements of a sequence ``s`` for which
  ## the element of a selector ``b`` is ``true``.
  ##
  ## Stops as soon as either ``s`` or ``b`` are exhausted.
  runnableExamples:
      let
        a = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
        b = [9.5, 8.1, 7.3]
        c = @['a', 'b', 'c', 'd', 'e']
        d = [true, false, true, true, false, true]
      var
        s1: seq[int] = @[]
        s2: seq[float] = @[]
        s3: seq[char] = @[]
      for x in compress(a, d):
        s1.add(x)
      for x in compress(b, d):
        s2.add(x)
      for x in compress(c, d):
        s3.add(x)
      doAssert s1 == @[1, 3, 4, 6]
      doAssert s2 == @[9.5, 7.3]
      doAssert s3 == @['a', 'c', 'd']

  let l = min(s.len, b.len)
  for i in 0 ..< l:
    if b[i]:
      yield s[i]


iterator dropWhile*[T](s: openArray[T], f: proc(a: T): bool): T =
  ## Iterator which drops the elements from a sequence ``s`` as long as the
  ## predicate is ``true``. Afterwards, it returns every element.
  runnableExamples:
      let
        a = @[1, 3, 7, 2, 1, 4]
        b = ['a', 'd', 'h', 'd']
      var
        s1: seq[int] = @[]
        s2: seq[int] = @[]
        s3: seq[char] = @[]
      proc myodd(a: int): bool = a mod 2 == 1
      proc mysmall(a: int): bool = a < 7
      proc mysmall(a: char): bool = a < 'h'

      for x in dropWhile(a, myodd):
        s1.add(x)
      for x in dropWhile(a, mysmall):
        s2.add(x)
      for x in dropWhile(b, mysmall):
        s3.add(x)
      doAssert s1 == @[2, 1, 4]
      doAssert s2 == @[7, 2, 1, 4]
      doAssert s3 == @['h', 'd']

  var i = 0
  while true and i < s.len:
    if not f(s[i]):
      yield s[i]
      inc i
      break
    inc i
  while i < s.len:
    yield s[i]
    inc i


iterator filterFalse*[T](s: openArray[T], f: proc(a: T): bool): T =
  ## Iterator which filters the container ``s`` and yields only the elements
  ## for which ``f`` is false.
  runnableExamples:
      let
        a = @[1, 3, 7, 2, 1, 4]
        b = ['a', 'd', 'h', 'd']
      var
        s1: seq[int] = @[]
        s2: seq[int] = @[]
        s3: seq[char] = @[]
      proc myodd(a: int): bool = a mod 2 == 1
      proc mysmall(a: int): bool = a < 7
      proc mysmall(a: char): bool = a < 'h'

      for x in filterFalse(a, myodd):
        s1.add(x)
      for x in filterFalse(a, mysmall):
        s2.add(x)
      for x in filterFalse(b, mysmall):
        s3.add(x)
      doAssert s1 == @[2, 4]
      doAssert s2 == @[7]
      doAssert s3 == @['h']

  for x in s:
    if not f(x):
      yield x


iterator groupBy*[T](s: openArray[T]): tuple[k: T, v: seq[T]] =
  ## Iterator which groups the same elements together, yielding a tuple
  ## ``(key, group)``.
  runnableExamples:
      let
        a = @[1, 2, 5, 2, 7, 5, 1, 2]
        b = ['a', 'b', 'b', 'a', 'b', 'a', 'n', 'd']
      var s1: seq[tuple[k: int, v: seq[int]]] = @[]
      var s2: seq[tuple[k: char, v: seq[char]]] = @[]

      for x in groupBy(a):
        s1.add(x)
      for x in groupBy(b):
        s2.add(x)
      doAssert s1 == @[(k: 1, v: @[1, 1]), (k: 2, v: @[2, 2, 2]),
                      (k: 5, v: @[5, 5]), (k: 7, v: @[7])]
      doAssert s2 == @[(k: 'a', v: @['a', 'a', 'a']), (k: 'b', v: @['b', 'b', 'b']),
                      (k: 'd', v: @['d']), (k: 'n', v: @['n'])]

  var t = initTable[T, seq[T]]()
  for x in s:
    if not t.hasKey(x):
      t[x] = @[]
    t[x].add(x)
  for x in t.pairs:
    yield x


iterator groupBy*[T, U](s: openArray[T], f: proc(a: T): U): tuple[k: U, v: seq[T]] =
  ## Iterator which groupse the elements based on applying a procedure ``f``
  ## on each element, yielding a tuple ``(key, group)``.
  runnableExamples:
      let
        a = @[1, 2, 5, 2, 7, 5, 1, 2]
        b = ['a', 'b', 'b', 'a', 'b', 'a', 'n', 'd']
        c = ["ac", "dc", "who", "cream", "clash"]
      proc isOdd(x: int): bool = x mod 2 == 1
      proc isA(x: char): bool = x == 'a'
      proc length(x: string): int = x.len

      var s1: seq[tuple[k: bool, v: seq[int]]] = @[]
      var s2: seq[tuple[k: bool, v: seq[char]]] = @[]
      var s3: seq[tuple[k: int, v: seq[string]]] = @[]

      for x in groupBy(a, isOdd):
        s1.add(x)
      for x in groupBy(b, isA):
        s2.add(x)
      for x in groupBy(c, length):
        s3.add(x)
      doAssert s1 == @[(k: true, v: @[1, 5, 7, 5, 1]), (k: false, v: @[2, 2, 2])]
      doAssert s2 == @[(k: true, v: @['a', 'a', 'a']),
                      (k: false, v: @['b', 'b', 'b', 'n', 'd'])]
      doAssert s3 == @[(k: 2, v: @["ac", "dc"]), (k: 3, v: @["who"]),
                      (k: 5, v: @["cream", "clash"])]

  var t = initTable[U, seq[T]]()
  for x in s:
    let fx = f(x)
    if not t.hasKey(fx):
      t[fx] = @[]
    t[fx].add(x)
  for x in t.pairs:
    yield x


iterator islice*[T](s: openArray[T], start = 0, stop = -1, step = 1): T =
  ## Iterator which yields elements of ``s``, starting from ``start`` (default = 0),
  ## until ``stop`` (default = -1, go to the end), with step-size ``step``
  ## (default = 1).
  runnableExamples:
      let
        a = @[1, 4, 3, 2, 5, 8, 6, 7, 9]
        b = [3.3, 4.4, 9.9, 6.6, 2.2]
      var
        s1: seq[int] = @[]
        s2: seq[int] = @[]
        s3: seq[float] = @[]
        s4: seq[float] = @[]
      for x in islice(a, 3):
        s1.add(x)
      for x in islice(a, 3, 5):
        s2.add(x)
      for x in islice(b, step = 2):
        s3.add(x)
      for x in islice(b, 1, 99, 2):
        s4.add(x)
      doAssert s1 == @[2, 5, 8, 6, 7, 9]
      doAssert s2 == @[2, 5, 8]
      doAssert s3 == @[3.3, 9.9, 2.2]
      doAssert s4 == @[4.4, 6.6]

  var
    i = start
    stop = stop
  if stop == -1 or stop >= s.len:
    stop = s.len - 1
  while i <= stop:
    yield s[i]
    i += step


iterator takeWhile*[T](s: openArray[T], f: proc(a: T): bool): T =
  ## Iterator which yields elements of ``s`` as long as predicate is true.
  runnableExamples:
      let
        a = @[1, 3, 5, 2, 7, 9]
        b = ['a', 'c', 'd', 'c']
      var
        s1: seq[int] = @[]
        s2: seq[int] = @[]
        s3: seq[char] = @[]
      proc myodd(a: int): bool = a mod 2 == 1
      proc mysmall(a: int): bool = a < 5
      proc mysmall(a: char): bool = a < 'd'

      for x in takeWhile(a, myodd):
        s1.add(x)
      for x in takeWhile(a, mysmall):
        s2.add(x)
      for x in takeWhile(b, mysmall):
        s3.add(x)
      doAssert s1 == @[1, 3, 5]
      doAssert s2 == @[1, 3]
      doAssert s3 == @['a', 'c']

  for x in s:
    if f(x):
      yield x
    else:
      break


iterator product*[T, U](s1: openArray[T], s2: openArray[U]): tuple[a: T, b: U] =
  ## Iterator producing tuples with Cartesian product of the arguments.
  ## Equivalent to nested for-loops.
  runnableExamples:
      let
        a = @[1, 2, 3]
        b = "ab"
      var s: seq[tuple[a: int, b: char]] = @[]
      for x in product(a, b):
        s.add(x)
      doAssert s == @[(a: 1, b: 'a'), (a: 1, b: 'b'), (a: 2, b: 'a'),
                      (a: 2, b: 'b'), (a: 3, b: 'a'), (a: 3, b: 'b')]

  for a in s1:
    for b in s2:
      yield (a, b)


iterator product*[T, U, V](s1: openArray[T], s2: openArray[U], s3: openArray[V]):
  tuple[a: T, b: U, c: V] =
  ## Iterator producing tuples with Cartesian product of the arguments.
  ## Equivalent to nested for-loops.
  runnableExamples:
      let
        a = @[1, 2]
        b = "ab"
        c = [9.9, 7.2]
      var s: seq[tuple[a: int, b: char, c: float]] = @[]
      for x in product(a, b, c):
        s.add(x)
      doAssert s == @[(a: 1, b: 'a', c: 9.9), (a: 1, b: 'a', c: 7.2),
                      (a: 1, b: 'b', c: 9.9), (a: 1, b: 'b', c: 7.2),
                      (a: 2, b: 'a', c: 9.9), (a: 2, b: 'a', c: 7.2),
                      (a: 2, b: 'b', c: 9.9), (a: 2, b: 'b', c: 7.2)]

  for a in s1:
    for b in s2:
      for c in s3:
        yield (a, b, c)


iterator product*[T, U, V, W](s1: openArray[T], s2: openArray[U], s3: openArray[V],
  s4: openArray[W]): tuple[a: T, b: U, c: V, d: W] =
  ## Iterator producing tuples with Cartesian product of the arguments.
  ## Equivalent to nested for-loops.
  runnableExamples:
      let
        a = @[1, 2]
        b = "a"
        c = [9.9]
        d = "xyz"
      var s: seq[tuple[a: int, b: char, c: float, d: char]] = @[]
      for x in product(a, b, c, d):
        s.add(x)
      doAssert s == @[(a: 1, b: 'a', c: 9.9, d: 'x'), (a: 1, b: 'a', c: 9.9, d: 'y'),
                      (a: 1, b: 'a', c: 9.9, d: 'z'), (a: 2, b: 'a', c: 9.9, d: 'x'),
                      (a: 2, b: 'a', c: 9.9, d: 'y'), (a: 2, b: 'a', c: 9.9, d: 'z')]

  for a in s1:
    for b in s2:
      for c in s3:
        for d in s4:
          yield (a, b, c, d)


iterator distinctPermutations*[T](s: openArray[T]): seq[T] =
  ## Iterator which yields distinct permutations of ``s``.
  ##
  ## Permutations are yielded in lexicographical order, without duplicates.
  ## If you want to include duplicates, use ``permutations``.
  runnableExamples:
      let
        a = "bab"
        b = "zzz"
      var
        s1: seq[seq[char]] = @[]
        s2: seq[seq[char]] = @[]
      for x in distinctPermutations(a):
        s1.add(x)
      for x in distinctPermutations(b):
        s2.add(x)
      doAssert s1 == @[@['a', 'b', 'b'], @['b', 'a', 'b'], @['b', 'b', 'a']]
      doAssert s2 == @[@['z', 'z', 'z']]

  var x = @s
  x.sort(cmp)
  yield x

  while x.nextPermutation():
    yield x


iterator permutations*[T](s: openArray[T]): seq[T] =
  ## Iterator which yields all (number of permutations = ``(s.len)!``)
  ## permutations of ``s``.
  ##
  ## If ``s`` contains duplicate elements, some permutations will be the same.
  ## If you want permutations without duplicates, use ``distinctPermutations``.
  runnableExamples:
      let
        a = "bab"
        b = "zzz"
      var
        s1: seq[seq[char]] = @[]
        s2: seq[seq[char]] = @[]
      for x in permutations(a):
        s1.add(x)
      for x in permutations(b):
        s2.add(x)
      doAssert s1 == @[@['b', 'a', 'b'], @['b', 'b', 'a'], @['a', 'b', 'b'],
                       @['a', 'b', 'b'], @['b', 'b', 'a'], @['b', 'a', 'b']]
      doAssert s2 == @[@['z', 'z', 'z'], @['z', 'z', 'z'], @['z', 'z', 'z'],
                       @['z', 'z', 'z'], @['z', 'z', 'z'], @['z', 'z', 'z']]

  var indices = newSeq[int](s.len)
  for i in 0 ..< s.len:
    indices[i] = i
  var x = @s

  for indPerm in distinctPermutations(indices):
    for i in 0 ..< s.len:
      x[i] = s[indPerm[i]]
    yield x


iterator combinations*(n, r: Positive): seq[int] =
  ## Iterator which yields combinations of size ``r`` of a range ``0 ..< n``.
  ##
  ## Both arguments must be positive numbers.
  runnableExamples:
      let
        a = 5
        b = 4
        c = 2
      var
        s1: seq[seq[int]] = @[]
        s2: seq[seq[int]] = @[]
      for x in combinations(a, b):
        s1.add(x)
      for x in combinations(a, c):
        s2.add(x)
      doAssert s1 == @[@[0, 1, 2, 3], @[0, 1, 2, 4], @[0, 1, 3, 4],
                       @[0, 2, 3, 4], @[1, 2, 3, 4]]
      doAssert s2 == @[@[0, 1], @[0, 2], @[0, 3], @[0, 4],
                       @[1, 2], @[1, 3], @[1, 4], @[2, 3], @[2, 4], @[3, 4]]

  var
    x = newSeq[int](r)
    stack = @[0]

  while stack.len > 0:
    var
      i = stack.high
      v = stack.pop()
    while v < n:
      x[i] = v
      inc v
      inc i
      stack.add(v)
      if i == r:
        yield x
        break


iterator combinations*[T](s: openArray[T], r: Positive): seq[T] =
  ## Iterator which yields combinations of ``s`` of length ``r``.
  ##
  ## Length ``r`` must be a positive number.
  runnableExamples:
      let
        a = "98765"
        b = 4
        c = 2
      var
        s1: seq[seq[char]] = @[]
        s2: seq[seq[char]] = @[]
      for x in combinations(a, b):
        s1.add(x)
      for x in combinations(a, c):
        s2.add(x)
      doAssert s1 == @[@['9', '8', '7', '6'], @['9', '8', '7', '5'],
                       @['9', '8', '6', '5'], @['9', '7', '6', '5'],
                       @['8', '7', '6', '5']]
      doAssert s2 == @[@['9', '8'], @['9', '7'], @['9', '6'], @['9', '5'],
                       @['8', '7'], @['8', '6'], @['8', '5'], @['7', '6'],
                       @['7', '5'], @['6', '5']]

  var x = newSeq[T](r)
  for indComb in combinations(s.len, r):
    for i in 0 ..< r:
      x[i] = s[indComb[i]]
    yield x



when isMainModule:
  # needed to run the tests in ``runnableExamples``
  discard count(3)()
  discard count(3.0, 2.5)()
  discard cycle(@[3, 4])()
  discard repeat(1)()
  for _ in accumulate(@[3, 5], proc(a, b: int): int = a + b): break
  for _ in chain(@[1], @[3]): break
  for _ in compress(@[1, 2], @[false, true]): break
  for _ in dropWhile(@[1, 2], proc(a: int): bool = a < 0): break
  for _ in filterFalse(@[1, 2], proc(a: int): bool = a < 0): break
  for _ in groupBy(@[1, 2], proc(x: int): bool = x mod 2 == 0): break
  for _ in islice(@[1, 2, 3], 2): break
  for _ in takeWhile(@[1, 2], proc(a: int): bool = a < 2): break
  for _ in product(@[1, 2], @[3, 4]): break
  for _ in product(@[1, 2], @[3, 4], @[5, 6]): break
  for _ in product(@[1, 2], @[3, 4], @[5, 6], @[7, 8]): break
  for _ in distinctPermutations(@[1, 2, 3]): break
  for _ in permutations(@[1, 2, 3]): break
  for _ in combinations(5, 2): break
  for _ in combinations(@[1, 2, 3], 2): break
