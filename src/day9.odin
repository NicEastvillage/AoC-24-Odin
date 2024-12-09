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

}