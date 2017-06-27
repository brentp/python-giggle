## Giggle

```Python

from giggle import Giggle
index = Giggle('existing-index-dir') # or Giggle.create('new-index-dir', 'files/*.bed')
print(index.files)

result = index.query('chr1', 9999, 20000)
print(result.n_files)
print(result.n_total_hits) # integer number sum of hits across all files

print(result.n_hits[0]) # integer number of hits for the 0th file...
print(result.n_hits) # list of integer hit-counts for each file in the index.

for hit in result[0]:
    print(hit) # hit is a string

# or by file name
for hit in result['files/my-file.bed']:
    print(hit) # hit is a string

```
