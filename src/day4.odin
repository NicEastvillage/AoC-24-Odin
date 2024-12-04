package main

import "core:fmt"

day4a :: proc(input: string) {
    WIDTH :: 142 // incl. \r\n newline
    HEIGHT :: 140
    DIRECTIONS :: [?]int{
        1, // right
        WIDTH + 1, // down right
        WIDTH, // down
        WIDTH - 1, // down left
        -1, // left
        -WIDTH - 1, // up left
        -WIDTH, // up
        -WIDTH + 1, // up right
    }

    res := 0
    for i in 0..<WIDTH * HEIGHT {
        if input[i] == 'X' {
            for d in DIRECTIONS {
                if 0 <= i + d * 3 \
                        && i + d * 3 < WIDTH * HEIGHT \
                        && input[i + 1 * d] == 'M' \
                        && input[i + 2 * d] == 'A' \
                        && input[i + 3 * d] == 'S' {
                    res += 1
                }
            }
        }
    }

    fmt.println(res)
}

day4b :: proc(input: string) {
    WIDTH :: 142 // incl. \r\n newline
    HEIGHT :: 140

    res := 0
    for i in WIDTH..<WIDTH * HEIGHT - WIDTH {
        if input[i] == 'A' && i %% WIDTH != 0 {
            SE := i + WIDTH + 1
            SW := i + WIDTH - 1
            NW := i - WIDTH - 1
            NE := i - WIDTH + 1

            ((input[SE] == 'M' && input[NW] == 'S') || (input[SE] == 'S' && input[NW] == 'M')) or_continue
            ((input[SW] == 'M' && input[NE] == 'S') || (input[SW] == 'S' && input[NE] == 'M')) or_continue

            res += 1
        }
    }

    fmt.println(res)
}
