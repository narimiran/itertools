# Itertools

This package is a Nim rewrite of a [very popular Python module](https://docs.python.org/3/library/itertools.html) of the same name.

&nbsp;




## Installation

```
nimble install itertools
```

Required Nim version is at least 0.18.0.

&nbsp;




## Supported iterators

* infinite iterators:
    * count
    * cycle
    * repeat

* terminating iterators:
    * accumulate
    * chain
    * compress
    * dropWhile
    * filterFalse
    * islice
    * takeWhile

&nbsp;




## Usage




### Infinite iterators

```nim
import itertools

let a = count(100, 30)
for _ in 1 .. 5:
  echo a()
# 100; 130; 160; 190; 220

let b = cycle(@["I", "repeat", "myself"])
for _ in 1 .. 8:
  echo b()
# I; repeat; myself; I; repeat; myself; I; repeat

let c = repeat("Beetlejuice")
for _ in 1 .. 3:
  echo c()
# Beetlejuice; Beetlejuice; Beetlejuice

let d = repeat(9.99, 4)
for x in d():
  echo x
# 9.99; 9.99; 9.99; 9.99
```




### Terminating iterators

```nim
import itertools
import future # to use `=>` for anonymous proc

let
  numbers = @[1, 3, 7, 8, 4, 2, 6, 5, 9]
  letters = ['a', 'c', 't', 'n', 'e', 'b']
# both sequences and arrays can be used


for i in accumulate(numbers, (x, y) => x + y):
  echo i
# 1; 4; 11; 19; 23; 25; 31; 36; 45 

for i in compress(letters, [true, true, false, true]):
  echo i
# a; c; n

for i in dropWhile(numbers, x => (x mod 2 == 1)):
  echo i
# 8; 4; 2; 6; 5; 9

for i in filterFalse(letters, x => (x in {'a', 'e', 'i', 'o', 'u'})):
  echo i
# c; t; n; b

for i in islice(numbers, 5):
  echo i
# 2; 6; 5; 9

for i in islice(letters, 1, step=2):
  echo i
# c; n; b

for i in islice(numbers, stop=5, step=2):
  echo i
# 1; 7; 4

for i in takeWhile(letters, x => (x != 'n')):
  echo i
# a; c; t

for i in chain(@[1, 3, 5], @[2, 4, 6], @[7, 8, 9]):
  echo i
# 1; 3; 5; 2; 4; 6; 7; 8; 9
```

For more examples, see the [documentation](https://rawgit.com/narimiran/itertools/master/itertools.html).

&nbsp;




## Contributing

There is probably a lot of room for improvement.
Feel free to fork the repo and submit your PRs.

Before submitting, run `nim doc src/itertools.nim` to make sure that all the asserts in `runnableExamples` are passing.

&nbsp;




## License

[MIT license](LICENSE.txt)
