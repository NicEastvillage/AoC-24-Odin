package main

import "core:fmt"
import "core:slice"

day10 :: proc(input: string, double_count: bool) {
    N :: 45
    grid : [N][N]i16 = ---
    heads_buf : [N*N][2]i16 = ---
    heads := slice.into_dynamic(heads_buf[:])
    for y in 0..<N {
        for x in 0..<N {
            grid[y][x] = i16(input[y * (N + 2) + x] - '0')
            if input[y * (N + 2) + x] - '0' == 0 {
                append(&heads, [?]i16{ i16(x), i16(y) })
            }
        }
    }

    find_trails_rec :: proc(pos: [2]i16, grid: ^[N][N]i16, seen: ^[dynamic][2]i16, double_count: bool) -> int {
        DIRECTIONS :: [?][2]i16{ { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, 0 } }
        if grid[pos.y][pos.x] == 9 {
            if double_count {
                return 1
            } else if !slice.contains(seen[:], pos) {
                append(seen, pos)
                return 1
            } else {
                return 0
            }
        }
        res := 0
        for dir in DIRECTIONS {
            nxt := pos + dir
            if 0 <= nxt.x && nxt.x < N && 0 <= nxt.y && nxt.y < N && grid[nxt.y][nxt.x] - 1 == grid[pos.y][pos.x] {
                res += find_trails_rec(nxt, grid, seen, double_count)
            }
        }
        return res
    }

    res := 0
    seen := make([dynamic][2]i16, 0, N * 2)
    for head in heads {
        clear(&seen)
        res += find_trails_rec(head, &grid, &seen, double_count)
    }
    fmt.println(res)
}
