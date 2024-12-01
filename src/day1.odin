package main

import "core:fmt"
import "core:text/scanner"
import "core:strconv"
import "core:slice/heap"

day1a :: proc(input: string) {

    less :: proc(a: int, b: int) -> bool {
        return a < b
    }

    N :: 1000
    left : [N]int = ---;
    right : [N]int = ---;

    scn : scanner.Scanner
    scanner.init(&scn, input)
    scn.flags = scanner.Scan_Flags{.Scan_Ints}

    for i in 0..<N {
        scanner.scan(&scn)
        left[i] = strconv.atoi(scanner.token_text(&scn))
        heap.push(left[:i+1], less)

        scanner.scan(&scn)
        right[i] = strconv.atoi(scanner.token_text(&scn))
        heap.push(right[:i+1], less)
    }

    sum := 0
    for i in 0..<N {
        sum += abs(left[0] - right[0])
        heap.pop(left[:N - i], less)
        heap.pop(right[:N - i], less)
    }

    fmt.println(sum)
}

day1b :: proc(input: string) {

    N :: 1000
    MIN :: 10_000
    MAX :: 100_000
    left : [MAX - MIN]i8;
    right : [MAX - MIN]i8;

    scn : scanner.Scanner
    scanner.init(&scn, input)
    scn.flags = scanner.Scan_Flags{.Scan_Ints}

    sum := 0
    for i in 0..<N {
        scanner.scan(&scn)
        l := strconv.atoi(scanner.token_text(&scn))
        left[l - MIN] += 1;
        sum += l * int(right[l - MIN])

        scanner.scan(&scn)
        r := strconv.atoi(scanner.token_text(&scn))
        right[r - MIN] += 1;
        sum += r * int(left[r - MIN])
    }

    fmt.println(sum)
}
