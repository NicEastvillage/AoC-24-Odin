package main

import "core:fmt"

day9a :: proc(input: []byte) {
    i := 0
    j := len(input) - 3
    k := 0 // pos in expanded
    id_back := j / 2
    id_front := 0
    is_block := true
    res := 0
    for i <= j {
        if is_block {
            if input[i] == '0' {
                is_block = false
                i += 1
            } else {
                input[i] -= 1
                res += k * id_front
                k += 1
            }
        } else {
            if input[i] == '0' {
                is_block = true
                i += 1
                id_front += 1
            } else if input[j] == '0' {
                j -= 2
                id_back -= 1
            } else {
                input[i] -= 1
                input[j] -= 1
                res += k * id_back
                k += 1
            }
        }
    }
    fmt.println(res)
}

day9b :: proc(input: string) {
    N :: 10000
    Node :: struct { id: u16, size, post_space: u8 }
    assert(len(input) - 1 == N * 2)

    // Build "free list"
    nodes := make([dynamic]Node, N)
    for i in 0..<N {
        assert(input[i * 2] != '0')
        nodes[i] = Node {
            id = u16(i),
            size = input[i * 2] - '0',
            post_space = input[i * 2 + 1] - '0',
        }
    }
    nodes[N - 1].post_space = 0

    // Defragmentation
    loc := N - 1
    for id := N - 1; id >= 0; id -= 1 {
        // Find slot
        prev := 0
        for prev < loc && nodes[prev].post_space < nodes[loc].size do prev += 1
        if prev < loc {
            // Move
            nodes[loc - 1].post_space += nodes[loc].size + nodes[loc].post_space
            post_space := nodes[prev].post_space - nodes[loc].size // Must come after line above since loc-1 could be prev
            n := nodes[loc]
            n.post_space = post_space
            ordered_remove(&nodes, loc)
            inject_at(&nodes, prev + 1, n)
            nodes[prev].post_space = 0
        }
        // Move to next
        for id > 0 && id - 1 != int(nodes[loc].id) do loc -= 1
    }

    // Checksum
    res := 0
    k := 0
    for i in 0..<N {
        for j in 0..<nodes[i].size {
            res += k * int(nodes[i].id)
            k += 1
        }
        k += int(nodes[i].post_space)
    }
    fmt.println(res)
}