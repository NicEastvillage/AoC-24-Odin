package main

import "core:fmt"

D5Node :: struct {
    predecessor_n: u8,
    successor_n: u8,
    successors: [30]u8,
}

read_po :: proc(input: string, nodes: []D5Node) -> int {
    lexer := Lexer{ input, 0, CharSet{'|'} }
    for {
        fst := lex_maybe_int(&lexer) or_break
        snd := lex_int(&lexer)
        node1 := &nodes[fst]
        node1.successors[node1.successor_n] = u8(snd)
        node1.successor_n += 1
        nodes[snd].predecessor_n += 1
        lex_to_next_line(&lexer)
    }
    return lexer.pos
}

build_po :: proc(nodes: []D5Node, order: []int) {
    N := len(nodes)
    if N != len(order) do panic("Length mismatch")

    todo_buf : [64]u8;
    todo_n := 0;

    k := 0

    for i in 0..<N {
        if nodes[i].predecessor_n == 0 {
            todo_buf[todo_n] = u8(i)
            todo_n += 1
        }
    }

    for todo_n > 0 {
        todo_n -= 1
        val := todo_buf[todo_n]

        order[val] = k
        k += 1
        fmt.println(val)

        fmt.println("Succs:", nodes[val].successor_n)
        for succ in nodes[val].successors[:nodes[val].successor_n] {
            nodes[succ].predecessor_n -= 1
            if nodes[succ].predecessor_n == 0 {
                fmt.println("Add", succ)
                todo_buf[todo_n] = succ
                todo_n += 1
            }
        }
    }

    fmt.println("Entries:", k)
}

day5a :: proc(input: string) {
    nodes : [100]D5Node
    pos := read_po(input, nodes[:])
    lexer := Lexer{ input, pos, CharSet{','}}
    lex_to_next_line(&lexer)
    seq : [25]u8
    n := 0
    res := 0
    for {
        seq[0] = u8(lex_maybe_int(&lexer) or_break)
        n := 1
        for {
            seq[n] = u8(lex_maybe_int(&lexer) or_break)
            n += 1
        }
        fmt.println(seq[:n])

        ok := true
        check: for i in 1..<n {
            for j in 0..<i {
                for succ in nodes[seq[i]].successors {
                    // bitset?
                    if succ == seq[j] {
                        ok = false
                        break check
                    }
                }
            }
        }
        if ok {
            res += int(seq[n / 2])
        }

        lex_to_next_line(&lexer)
    }

    fmt.println(res)
}

day5b :: proc(input: string) {

}