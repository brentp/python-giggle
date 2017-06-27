from libc.stdint cimport int32_t, uint32_t, int8_t, int16_t, uint8_t

cdef extern from "ll.h":
    void uint64_t_ll_giggle_set_data_handler()

cdef extern from "giggle_index.h":

    cdef struct giggle_index:
        pass

    cdef struct giggle_query_result:
        giggle_index *gi;
        uint32_t num_files;
        uint32_t num_hits;
        

    void giggle_index_destroy(giggle_index *gi)


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


    ctypedef struct giggle_def:
        #struct cache_handler non_leading_cache_handler;
        #struct cache_handler leading_cache_handler;
        void *(*new_non_leading)(uint32_t domain);
        void *(*new_leading)(uint32_t domain);
        void (*non_leading_SA_add_scalar)(uint32_t domain,
                                      void *non_leading,
                                      void *scalar);
        void (*non_leading_SE_add_scalar)(uint32_t domain, 
                                      void *non_leading,
                                      void *scalar);
        void (*leading_B_add_scalar)(uint32_t domain,
                                 void *leading,
                                 void *scalar);
        void (*leading_union_with_B)(uint32_t domain,
                                 void **result,
                                 void *leading);
        void (*non_leading_union_with_SA)(uint32_t domain,
                                      void **result,
                                      void *non_leading);
        void (*non_leading_union_with_SA_subtract_SE)(uint32_t domain,
                                                  void **result,
                                                  void *non_leading);
        void (*write_tree)(void *arg);
        void *(*giggle_collect_intersection)(uint32_t leaf_start_id,
                                         int pos_start_id,
                                         uint32_t leaf_end_id,
                                         int pos_end_id,
                                         uint32_t domain,
                                         void **r);
        void (*map_intersection_to_offset_list)(giggle_index *gi,
                                            giggle_query_result *gqr,
                                            void *_R);

