package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:time"

main :: proc() {
    if len(os.args) != 2 {
        fmt.eprintln("Expected 1 argument, a number in range 0..25 followed by either 'a' or 'b', e.g. \"2a\"")
        return
    }
    arg := os.args[1]
    variant := arg[len(arg) - 1]
    if variant != 'a' && variant != 'b' {
        fmt.eprintf("Argument does not end with 'a' nor 'b', got '%c'", variant)
        return
    }
    day, ok := strconv.parse_int(arg[:len(arg)-1])
    if !ok {
        fmt.eprintf("Argument is not a number followed by 'a' or 'b', got '%v'", arg)
        return
    }
    if day < 0 || 25 < day {
        fmt.eprint("Argument number is out of bounds, expected number in range 0..25, got", day)
        return
    }

    file_name := fmt.aprintf("input/day%d.txt", day)
    data := os.read_entire_file_or_err(file_name) or_else panic(strings.concatenate({"Failed to open '", file_name, "'. Does it exist?"}))

    input := string(data)
    fmt.printfln("Evaluating day %v%c:", day, variant)
    start_tick := time.tick_now()
    switch day {
    case 0: day0(input)
    case 1: if variant == 'a' do day1a(input); else do day1b(input)
    case 2: if variant == 'a' do day2a(input); else do day2b(input)
    case 3: if variant == 'a' do day3a(input); else do day3b(input)
    case 4: if variant == 'a' do day4a(input); else do day4b(input)
    case 5: day5(input)
    case 6: day6(input)
    case 7: if variant == 'a' do day7a(input); else do day7b(input)
    case 8: if variant == 'a' do day8a(input); else do day8b(input)
    case 9: if variant == 'a' do day9a(data); else do day9b(input)
    case: panic("Not implemented yet")
    }
    duration := time.tick_since(start_tick)
    fmt.println(duration)
}

day0 :: proc(input: string) {
    fmt.println(input);
}
