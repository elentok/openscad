// type = "fieldnotes";
// type = "traveler-regular";
// type = "a6";

function get_notebook_size(type) = type == "traveler-regular" ? [ 110, 210 ]
                                   : type == "fieldnotes"     ? [ 90, 140 ]
                                                              : [ 105, 148 ];
