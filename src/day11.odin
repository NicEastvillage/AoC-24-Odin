package main

import "core:fmt"

day11a :: proc(input: string) {
    BLINKS :: 25
    // Key in map: current stone engraving.
    // Index *i*: number of stones after *i* + 1 blinks.
    cache := make(map[int][BLINKS]int) // Leaked
    calc :: proc(val: int, blinks_left: int, cache: ^map[int][BLINKS]int) -> int {
        //for _ in 0..<BLINKS - blinks_left do fmt.print('|')
        //fmt.println(val)
        if blinks_left == 0 do return 1
        if val not_in cache do cache[val] = [BLINKS]int{ 0..<BLINKS = 0 }
        arr := &cache[val]
        if arr[blinks_left - 1] != 0 do return arr[blinks_left - 1]

        k := 0
        if val == 0 do k = calc(1, blinks_left - 1, cache)
        else if 10 <= val && val < 100 {
            k += calc(val / 10, blinks_left - 1, cache)
            k += calc(val %% 10, blinks_left - 1, cache)
        } else if 1000 <= val && val < 10_000 {
            k += calc(val / 100, blinks_left - 1, cache)
            k += calc(val %% 100, blinks_left - 1, cache)
        } else if 100_000 <= val && val < 1_000_000 {
            k += calc(val / 1_000, blinks_left - 1, cache)
            k += calc(val %% 1_000, blinks_left - 1, cache)
        } else if 10_000_000 <= val && val < 100_000_000 {
            k += calc(val / 10_000, blinks_left - 1, cache)
            k += calc(val %% 10_000, blinks_left - 1, cache)
        } else if 1_000_000_000 <= val && val < 10_000_000_000 {
            k += calc(val / 100_000, blinks_left - 1, cache)
            k += calc(val %% 100_000, blinks_left - 1, cache)
        } else if 100_000_000_000 <= val && val < 1_000_000_000_000 {
            k += calc(val / 1_000_000, blinks_left - 1, cache)
            k += calc(val %% 1_000_000, blinks_left - 1, cache)
        } else if 100_000_000_000_000 < val {
            fmt.println(val)
            panic("BIG NUMBERS")
        } else {
            k = calc(val * 2024, blinks_left - 1, cache)
        }
        //arr[blinks_left - 1] = k // FIXME: Cache does not work??
        return k
    }
    lexer := Lexer{ input, 0, Cs_SpaceTabs }
    res := 0
    for do res += calc(int(lex_maybe_int(&lexer) or_break), BLINKS, &cache)
    fmt.println(res, len(cache))
}

day11b :: proc(input: string) {

}