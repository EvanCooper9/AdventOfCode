#!/bin/bash
for i in {01..25}; do 
    day=$(printf "%02d\n" $i)
    echo "import AOCKit
import Algorithms

final class Day$day: Solution {
    override func question1() -> Any {
        fatalError()
    }

    override func question2() -> Any {
        fatalError()
    }
}" > "Day$day.swift"
    touch "Inputs/Day$day.txt"
done