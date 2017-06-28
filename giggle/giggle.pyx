#cython: embedsignature=True
from __future__ import print_function
from libc.stdlib cimport free
import sys
import locale

cdef class Giggle:

    cdef giggle_index *gi
    cdef list _files
    cdef char *path

    def __init__(self, char *path):
        self.path = path
        self.gi = giggle_load(to_bytes(path), block_store_giggle_set_data_handler)
        self._files = []

    def query(self, chrom, int start, int end):
        cdef giggle_query_result *gqr
        gqr = giggle_query(self.gi, to_bytes(chrom), start, end, NULL)
        cdef Result res = make_query_result(gqr)
        return res

    @classmethod
    def create(self, char *path, char *glob):
        giggle_bulk_insert(to_bytes(glob), to_bytes(path), 1)
        return Giggle(path)

    @property
    def files(self):
        if len(self._files) > 0: return self._files
        cdef char** names
        cdef uint32_t *n_intervals
        cdef double *mean_size
        cdef int n_files = giggle_get_indexed_files(self.path, &names, &n_intervals, &mean_size)
        self._files = [names[i] for i in range(n_files)]
        free(names)
        return self._files


cdef class Result:
    cdef giggle_query_result *gqr
    def __dealloc__(self):
        giggle_query_result_destroy(&self.gqr)

    @property
    def n_files(self):
        return self.gqr.num_files

    @property
    def n_total_hits(self):
        return self.gqr.num_hits

    def n_hits(self, int idx):
        return giggle_get_query_len(self.gqr, idx)

    def __getitem__(self, int idx):
        cdef giggle_query_iter *gqi = giggle_get_query_itr(self.gqr, idx)
        return make_query_iter(gqi)

cdef class Iter:
    cdef giggle_query_iter *gqi

    def __dealloc__(self):
        giggle_iter_destroy(&self.gqi)

    def __iter__(self):
        return self

    def __next__(self):
        # TODO: fix memory leak by wrapping to python?
        cdef char *result
        res = giggle_query_next(self.gqi, &result)
        if res != 0:
            raise StopIteration
        return result

cdef inline Iter make_query_iter(giggle_query_iter *gqi):
    cdef Iter i = Iter.__new__(Iter)
    i.gqi = gqi
    return i

cdef inline Result make_query_result(giggle_query_result *gqr):
    cdef Result r = Result.__new__(Result)
    r.gqr = gqr
    return r


ENC = locale.getpreferredencoding()

cdef to_bytes(s, enc=ENC):
    if not isinstance(s, bytes):
        return s.encode(enc)
    return s
