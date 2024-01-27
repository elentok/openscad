function split_path(path, i) = is_undef(i) ? split_path(path, 1)
                               : i >= len(path)
                                   ? []
                                   : concat([[path [i - 1], path [i]]],
                                            split_path(path, i + 1));
