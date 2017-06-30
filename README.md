## Giggle

```Python

from giggle import Giggle
index = Giggle('existing-index-dir') # or Giggle.create('new-index-dir', 'files/*.bed')
print(index.files)

result = index.query('chr1', 9999, 20000)
print(result.n_files)
print(result.n_total_hits) # integer number sum of hits across all files

print(result.n_hits(0)) # integer number of hits for the 0th file...

for hit in result[0]:
    print(hit) # hit is a string
```

### Installation

make sure you have `liz`, `libcurl`, `libcrypto`, `libbz2` and `liblzma` installed in the appropriate
place on your system.
```
git clone --recursive https://github.com/brentp/python-giggle
cd python-giggle
python setup.py test
python setup.py install
```

