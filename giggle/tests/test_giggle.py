from __future__ import print_function
from giggle import Giggle
import os
import sys

HERE = os.path.dirname(__file__)
INDEX = os.path.join(HERE, "test-index")

def teardown():
    import shutil
    if os.path.exists(INDEX):
        shutil.rmtree(INDEX)

def setup():
    import shutil
    if os.path.exists(INDEX):
        shutil.rmtree(INDEX)
    Giggle.create(INDEX, "lib/giggle/test/data/many/*.bed.gz")

def test_load():
    g = Giggle(INDEX)

def test_query():
    g = Giggle(INDEX)
    res = g.query('chr1', 14135106, 16279607)
    assert res.n_total_hits == 65, res.n_total_hits

    tot = 0
    for i in range(0, res.n_files):
        tot += res.n_hits(i)
    assert tot == res.n_total_hits

def test_result_iter():
    g = Giggle(INDEX)
    res = g.query('chr1', 14135106, 16279607)
    lines = 0
    for i in range(0, res.n_files):
        for r in res[i]:
            lines += 1
    assert lines == res.n_total_hits, (lines, res.n_total_hits)

def test_files():
    g = Giggle(INDEX)
    assert len(g.files) != 0, g.files
    for f in g.files:
        assert f.endswith(".bed.gz")


def test_leak():
    g = Giggle(INDEX)
    res = g.query('chr1', 4135106, 116279607)

    j = 0
    while j < 1000000:
        j += 1
        tot = 0
        for i in range(0, res.n_files):
            tot += res.n_hits(i)
        assert tot == res.n_total_hits
