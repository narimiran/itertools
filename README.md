# Itertools

This package is a Nim rewrite of a [very popular Python module](https://docs.python.org/3/library/itertools.html) of the same name.

It also includes some of the iterators from [iterutils](https://boltons.readthedocs.io/en/latest/iterutils.html).

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
    * groupBy
    * groupConsecutive
    * islice
    * takeWhile

* combinatoric iterators:
    * product
    * distinctPermutations
    * permutations
    * combinations

* iterutils iterators:
    * chunked
    * windowed
    * pairwise
    * unique


&nbsp;




## Usage

For more comprehensive examples, see the [documentation](https://narimiran.github.io/itertools).



### Infinite iterators

WARNING: Version 0.3.0 introduced breaking changes regarding how these three iterators are implemented and used.
See the examples below for the new behaviour.

```nim
import itertools

for i in count(5):
  if i > 9: break
  echo i
# 5; 6; 7; 8; 9

for i in count(100, 30):
  if i > 200: break
  echo i
# 100; 130; 160; 190

var n = 0
for i in @["I", "repeat", "myself"].cycle:
  inc n
  if n > 8: break
  echo i
# I; repeat; myself; I; repeat; myself; I; repeat

for i in "Beetlejuice".repeat(3):
  echo i
# Beetlejuice; Beetlejuice; Beetlejuice

var k = 0
for i in "forever".repeat:
  inc k
  if k > 6: break
  echo i
# forever; forever; forever; forever; forever; forever
```




### Terminating iterators

```nim
import itertools
import future # to use `=>` for anonymous proc


let # you can use: sequences, arrays, strings
  numbers = @[1, 3, 7, 8, 4, 2, 6, 5, 9]
  constants = [2.7183, 3.1416, 1.4142, 1.7321]
  word = "abracadabra"


for i in accumulate(constants, (x, y) => x + y):
  echo i
# 2.7183; 5.8599; 7.2741; 9.0062

for i in compress(numbers, [true, true, false, true, false, true]):
  echo i
# 1; 3; 8; 2

for i in dropWhile(numbers, x => (x != 8)):
  echo i
# 8; 4; 2; 6; 5; 9

for i in filterFalse(word, x => (x == 'a')):
  echo i
# b; r; c; d; b; r

for key, group in numbers.groupBy(x => x mod 2 == 0):
  echo "key: ", key, " group: ", group
# key: true, group: @[8, 4, 2, 6]; key: false, group: @[1, 3, 7, 5, 9]

for key, group in word.groupBy():
  echo group
# @['a', 'a', 'a', 'a', 'a']; @['b', 'b']; @['c']; @['d']; @['r', 'r']

for key, group in groupConsecutive("aaabaabb"):
  echo group
# @['a', 'a', 'a']; @['b']; @['a', 'a']; @['b', 'b']

for i in islice(numbers, 5):
  echo i
# 2; 6; 5; 9

for i in islice(word, 1, step=2):
  echo i
# b; a; a; a; r

for i in islice(numbers, stop=5, step=2):
  echo i
# 1; 7; 4

for i in takeWhile(constants, x => (x >= 2.0)):
  echo i
# 2.7183; 3.1416

for i in chain(@[1, 3, 5], @[2, 4, 6], @[7, 8, 9]):
  echo i
# 1; 3; 5; 2; 4; 6; 7; 8; 9
```




### Combinatoric iterators

```nim
import itertools
import strutils # to join seq[char] into a string


let # you can use: sequences, arrays, strings
  numbers = @[1, 3, 7, 8, 4]
  constants = [2.7183, 3.1416]
  word = "abba"


for i in product([0, 1], repeat = 3):
  echo i
# @[0, 0, 0]; @[0, 0, 1]; @[0, 1, 0]; @[0, 1, 1]; @[1, 0, 0]; @[1, 0, 1]; @[1, 1, 0]; @[1, 1, 1]

for i in product(numbers, constants):
  echo i
# (a: 1, b: 2.7183); (a: 1, b: 3.1416); (a: 3, b: 2.7183); (a: 3, b: 3.1416); (a: 7, b: 2.7183); (a: 7, b: 3.1416); (a: 8, b: 2.7183); (a: 8, b: 3.1416); (a: 4, b: 2.7183); (a: 4, b: 3.1416)

for i in distinctPermutations(word):
  echo i.join
# aabb; abab; abba; baab; baba; bbaa

for i in permutations(word):
  echo i.join
# abba; abab; abba; abab; aabb; aabb; baba; baab; bbaa; bbaa; baab; baba; baba; baab; bbaa; bbaa; baab; baba; aabb; aabb; abab; abba; abab; abba

for i in combinations(5, 3):
  echo i
# @[0, 1, 2]; @[0, 1, 3]; @[0, 1, 4]; @[0, 2, 3]; @[0, 2, 4]; @[0, 3, 4]; @[1, 2, 3]; @[1, 2, 4]; @[1, 3, 4]; @[2, 3, 4]

for i in combinations(numbers, 2):
  echo i
# @[1, 3]; @[1, 7]; @[1, 8]; @[1, 4]; @[3, 7]; @[3, 8]; @[3, 4]; @[7, 8]; @[7, 4]; @[8, 4]
```




### Iterutils iterators

```nim
import itertools


let # you can use: sequences, arrays, strings
  numbers = @[1, 3, 7, 8, 4, 2, 6, 5, 9]
  constants = [2.7183, 3.1416, 1.4142, 1.7321]
  word = "abracadabra"


for i in chunked(numbers, 3):
  echo i
# @[1, 3, 7]; @[8, 4, 2]; @[6, 5, 9]

for i in windowed(numbers, 4):
  echo i
# @[1, 3, 7, 8]; @[3, 7, 8, 4]; @[7, 8, 4, 2]; @[8, 4, 2, 6]; @[4, 2, 6, 5]; @[2, 6, 5, 9]

for i in pairwise(constants):
  echo i
# @[2.7183, 3.1416]; @[3.1416, 1.4142]; @[1.4142, 1.7321]

for i in unique(word):
  echo i
# a; b; r; c; d
```


&nbsp;




## Contributing

There is probably a lot of room for improvement.
Feel free to fork the repo and submit your PRs.

Before submitting, run `nim doc -o:./docs/index.html ./src/itertools.nim` to make sure that all the asserts in `runnableExamples` are passing.


&nbsp;




## License

[MIT license](LICENSE.txt)
