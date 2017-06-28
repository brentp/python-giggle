from libc.stdint cimport uint32_t, uint32_t, int8_t, int16_t, uint8_t, uint64_t

cdef extern from "ll.h":
    void uint64_t_ll_giggle_set_data_handler()

cdef extern from "giggle_index.h":

    void block_store_giggle_set_data_handler()

    cdef struct giggle_index:
        pass


    uint32_t giggle_get_indexed_files(char *index_dir_name,
                                  char ***names,
                                  uint32_t **num_intervals,
                                  double **mean_interval_sizes);

    cdef struct giggle_query_result:
        giggle_index *gi;
        uint32_t num_files;
        uint32_t num_hits;

    cdef struct giggle_query_iter:
        giggle_index *gi;
        uint32_t file_id, curr, num;

    void giggle_index_destroy(giggle_index *gi)

    uint64_t giggle_bulk_insert(char *input_path_name,
                            char *output_path_name,
                            uint32_t force)

    giggle_index *giggle_load(char *data_dir,
                              void (*giggle_set_data_handler)());

    void *giggle_query_region(giggle_index *gi,
                          char *chrm,
                          uint32_t start,
                          uint32_t end);

    giggle_query_result *giggle_query(giggle_index *gi,
                                        char *chrm,
                                        uint32_t start,
                                        uint32_t end,
                                        giggle_query_result *gqr);
    void giggle_query_result_destroy(giggle_query_result **gqr)

    giggle_query_iter *giggle_get_query_itr(giggle_query_result *gqr,
                                            uint32_t file_id);

    uint32_t giggle_get_query_len(giggle_query_result *gqr,
                                  uint32_t file_id);
    int giggle_query_next(giggle_query_iter *gqi,
                          char **result);


    void giggle_iter_destroy(giggle_query_iter **gqi);

    giggle_index *giggle_init(uint32_t num_chrms,
                              char *output_dir,
                              uint32_t force,
                              void (*giggle_set_data_handler)());


    void leaf_data_map_intersection_to_offset_list(giggle_index *gi,
                                               giggle_query_result *gqr,
                                               void *_R);

    void *giggle_collect_intersection_data_in_block(uint32_t leaf_start_id,
                                                int pos_start_id,
                                                uint32_t leaf_end_id,
                                                int pos_end_id,
                                                uint32_t domain,
                                                void **r);


    cdef struct giggle_def:
        pass

    cdef giggle_def giggle_data_handler;

