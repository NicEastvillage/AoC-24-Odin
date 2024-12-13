package main

import "core:fmt"

day12a :: proc(input: string) {
    N :: 140
    DIRECTIONS :: [?]int{ -1, 1, - N - 2, N + 2 }
    Field :: struct { area, perim: int }
    visited : [N * (N + 2)]bool

    find_field_rec :: proc(field: ^Field, crop: u8, i: int, visited: ^[N * (N + 2)]bool, input: string) {
        visited[i] = true
        field.area += 1
        for dir in DIRECTIONS {
            n := i + dir
            if 0 <= n && n < N * (N + 2) && input[n] == crop {
                if !visited[n] do find_field_rec(field, crop, n, visited, input)
            } else {
                field.perim += 1
            }
        }
    }

    res := 0
    for y in 0..<N {
        yy := y * (N + 2)
        for x in 0..<N {
            i := yy + x
            if !visited[i] {
                field := Field{}
                find_field_rec(&field, input[i], i, &visited, input)
                res += field.area * field.perim
            }
        }
    }

    fmt.println(res)
}

day12b :: proc(input: string) {
    N :: 140
    Field :: struct { id, area, corners: int } // Note: corner count == side count
    id_grid : [N * (N + 2)]int

    find_field_rec :: proc(field: ^Field, crop: u8, i: int, id_grid: ^[N * (N + 2)]int, input: string) {
        @(static) DIRECTIONS := [?]int{ -(N + 2), 1, N + 2, -1 } // Up, right, down, left
        id_grid[i] = field.id
        field.area += 1
        diff : [4]bool
        for dir, d in DIRECTIONS {
            n := i + dir
            if 0 <= n && n < N * (N + 2) && input[n] == crop {
                if id_grid[n] == 0 {
                    find_field_rec(field, crop, n, id_grid, input)
                    for f := 1; f < 4; f += 2 {
                        n2 := i + dir + DIRECTIONS[(d + f) %% 4]
                        if 0 <= n2 && n2 < N * (N + 2) && input[n2] == crop && id_grid[n2] == 0 {
                            find_field_rec(field, crop, n2, id_grid, input)
                        }
                    }
                }
            } else {
                diff[d] = true
            }
        }
        for y := 0; y < 4; y += 2 {
            for x := 1; x < 4; x += 2 {
                dx := DIRECTIONS[x]
                dy := DIRECTIONS[y]
                c := i + dx + dy
                if diff[x] && diff[y] do field.corners += 1
                else if !diff[x] && !diff[y] && id_grid[c] != field.id do field.corners += 1
            }
        }
    }

    id := 0
    res := 0
    for y in 0..<N {
        yy := y * (N + 2)
        for x in 0..<N {
            i := yy + x
            if id_grid[i] == 0 {
                id += 1
                field := Field{ id = id }
                find_field_rec(&field, input[i], i, &id_grid, input)
                res += field.area * field.corners
            }
        }
    }

    fmt.println(res)
}