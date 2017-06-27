#cython: embedsignature=True

cdef class Giggle:

    cdef giggle_index *gi

    def __init__(self, path):
        self.gi = giggle_load(path, uint64_t_ll_giggle_set_data_handler)

    def query(self, chrom, int start, int end):
        cdef giggle_query_result *gqr = giggle_query(self.gi, chrom, start, end, NULL)
        return make_query_result(gqr)

cdef class Result:
    cdef giggle_query_result *gqr

cdef Result make_query_result(giggle_query_result *gqr):
    cdef Result r = Result.__new__(Result)
    r.gqr = gqr
    return r
