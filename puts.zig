pub fn puts(str: [*:0]const u8) c_int {
    return asm volatile (
        \\ li $9, 0x3f
        \\ j 0xa0
        : [ret] "={r2}" (-> c_int)
        : [str] "{r4}" (str)
    );
}
