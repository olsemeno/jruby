exclude :test_memsize_of_root_shared_string, "we don't share strings yet"
exclude :test_dump_flags, "we don't expose the same GC information as MRI"
exclude :test_dump_to_default, "object attributes are not the same as MRI"
exclude :test_dump_to_io, "uses a pipe in a way that isn't quite working for us"
exclude :test_dump_uninitialized_file, "needs spawn"
exclude :test_reachable_objects_from, "needs spawn"
exclude :test_reachable_objects_size, "needs spawn"
exclude :test_dump_all, "needs spawn"
exclude :test_argf_memsize, "we store ext as an ivar so it doesn't show up in the object size as they expect"
exclude :"test_count_imemo_objects", "needs investigation"
exclude :"test_count_symbols", "needs investigation"
exclude :"test_count_tdata_objects", "needs investigation"
exclude :"test_dump_dynamic_symbol", "needs investigation"
exclude :"test_internal_class_of", "needs investigation"
exclude :"test_internal_super_of", "needs investigation"
exclude :"test_memsize_of_iseq", "needs investigation"
exclude :"test_trace_object_allocations", "needs investigation"
exclude :test_count_objects_size, "needs investigation"
exclude :test_dump_special_consts, "needs investigation"
exclude :test_memsize_of, "needs investigation"
exclude :test_memsize_of_all, "needs investigation"