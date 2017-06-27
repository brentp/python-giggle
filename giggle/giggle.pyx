#cython: embedsignature=True
import locale

cdef class Giggle:

    cdef giggle_index *gi

    def __init__(self, char *path):
        self.gi = giggle_load(to_bytes(path), uint64_t_ll_giggle_set_data_handler)

    def query(self, chrom, int start, int end):
        cdef giggle_query_result *gqr = giggle_query(self.gi, chrom, start, end, NULL)
        return make_query_result(gqr)

    @classmethod
    def create(self, char *path, char *glob):
        giggle_bulk_insert(to_bytes(glob), to_bytes(path), 1)
        return Giggle(path)

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
        cdef char *result
        res = giggle_query_next(self.gqi, &result)
        if res <= 0:
            raise StopIteration
        return result

cdef Iter make_query_iter(giggle_query_iter *gqi):
    cdef Iter i = Iter.__new__(Iter)
    i.gqi = gqi
    return i

cdef Result make_query_result(giggle_query_result *gqr):
    cdef Result r = Result.__new__(Result)
    r.gqr = gqr
    return r


ENC = locale.getpreferredencoding()

cdef to_bytes(s, enc=ENC):
    if not isinstance(s, bytes):
        return s.encode(enc)
    return s
