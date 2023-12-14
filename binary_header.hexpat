struct string {
    u8 len;
    char chars[len];
};

struct header {
    u8 ints_count;
    s64 ints[ints_count];
    u8 floats_count;
    double floats[floats_count];
    u8 strings_count;
    string strings[strings_count];
};

header header @ 0x0;
