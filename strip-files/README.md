Can you write a Bash program that takes two files, "big-list.txt" and "files-to-strip.txt", and strips from big-list.txt any line that contains the entirety of any line in files-to-strip.txt?

For instance, if big-list.txt were the following:
```
a b c
d e f
g h i
j k l
```

and files-to-strip.txt were the following:
```
a
b
g
```

then the result should be the following:
```
d e f
j k l
```
