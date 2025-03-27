usage () {
    echo "Usage: ./export [part]"
    echo "Example: \`./export 1\` to export part 1."
    exit 1
}

export_part_1 () {
    rm -rf snarkjs_part_1

    mkdir snarkjs_part_1
    mkdir snarkjs_part_1/mycircuits
    mkdir snarkjs_part_1/mycircuits_solutions

    pandoc --include-in-header=./styling.css -s -f markdown+smart --metadata pagetitle="SnarkJS Part I" --to=html5 README_1.md -o ./snarkjs_part_1/README.html

    cp compose.yml ./snarkjs_part_1/
    cp Dockerfile ./snarkjs_part_1/
    cp snarkjs.1.1.0.dockerimage ./snarkjs_part_1/


    cat ./mycircuits/tiny_multiplication.circom | ./solution_parser.py exercises > ./snarkjs_part_1/mycircuits/tiny_multiplication.circom
    cat ./mycircuits/isEqual.circom | ./solution_parser.py exercises > ./snarkjs_part_1/mycircuits/isEqual.circom
    cat ./mycircuits/isBinary.circom | ./solution_parser.py exercises > ./snarkjs_part_1/mycircuits/isBinary.circom
    cat ./mycircuits/isBinaryRepr.circom | ./solution_parser.py exercises > ./snarkjs_part_1/mycircuits/isBinaryRepr.circom

    cat ./mycircuits/tiny_multiplication.circom | ./solution_parser.py solutions > ./snarkjs_part_1/mycircuits_solutions/tiny_multiplication.circom
    cat ./mycircuits/isEqual.circom | ./solution_parser.py solutions > ./snarkjs_part_1/mycircuits_solutions/isEqual.circom
    cat ./mycircuits/isBinary.circom | ./solution_parser.py solutions > ./snarkjs_part_1/mycircuits_solutions/isBinary.circom
    cat ./mycircuits/isBinaryRepr.circom | ./solution_parser.py solutions > ./snarkjs_part_1/mycircuits_solutions/isBinaryRepr.circom

    zip -r snarkjs_part_1.zip ./snarkjs_part_1/ 
    rm -r ./snarkjs_part_1/
}

export_part_2 () {
    rm -rf snarkjs_part_2

    mkdir snarkjs_part_2
    mkdir snarkjs_part_2/mycircuits
    mkdir snarkjs_part_2/mycircuits_solutions

    pandoc --include-in-header=./styling.css -s -f markdown+smart --metadata pagetitle="SnarkJS Part II" --to=html5 README_2.md -o ./snarkjs_part_2/README.html

    cp -r ./mycircuits/circomlib ./snarkjs_part_2/mycircuits/
    cat ./mycircuits/mastermind.circom | ./solution_parser.py exercises > ./snarkjs_part_2/mycircuits/mastermind.circom
    cat ./mycircuits/mastermind.circom | ./solution_parser.py solutions iterative > ./snarkjs_part_2/mycircuits_solutions/mastermind_solutions_iterative.circom
    cat ./mycircuits/mastermind.circom | ./solution_parser.py solutions recursive > ./snarkjs_part_2/mycircuits_solutions/mastermind_solutions_recursive.circom

    zip -r snarkjs_part_2.zip ./snarkjs_part_2/ 
    rm -r ./snarkjs_part_2/
}

export_part_3 () {
    rm -rf snarkjs_part_3

    mkdir snarkjs_part_3
    mkdir snarkjs_part_3/mastermind_app

    pandoc --include-in-header=./styling.css -s -f markdown+smart --metadata pagetitle="SnarkJS Part III" --to=html5 README_3.md -o ./snarkjs_part_3/README.html

    cp  ./mastermind_app/package.json ./snarkjs_part_3/mastermind_app/
    cat ./mastermind_app/index.js | ./solution_parser.py exercises > ./snarkjs_part_3/mastermind_app/index.js
    cat ./mastermind_app/index.js | ./solution_parser.py solutions > ./snarkjs_part_3/mastermind_app/index_solutions.js

    zip -r snarkjs_part_3.zip ./snarkjs_part_3/ 
    rm -r ./snarkjs_part_3/
}

if  [ "$#" -ne 1 ]; then
    echo "Error: Script needs 1 argument, $# given."
    usage
fi

if [ "$1" -eq 1 ]; then
    export_part_1
elif [ "$1" -eq 2 ]; then
    export_part_2
elif [ "$1" -eq 3 ]; then
    export_part_3
else
    echo "Error: argument has to be in {1,2,3}, '$1' given."
    usage
fi
