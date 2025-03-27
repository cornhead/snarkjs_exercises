pragma circom 2.1.9; // specify compiler version

/*
    Multiply takes two field elements as input
    and outputs their product as output
*/
template Multiply() {
    signal input in1;
    signal input in2;
    signal output out;

    ===START SOLUTION===
    out <== in1*in2;
    ===END SOLUTION===
}


/*
    Multiply is the main component of our circuit.
    Only in1 and out are marked as public values.
    That is, the prover proves that it knows a value
    in2 such that out = in1*in2.

    Question: For what other operation can we use
    this gadget other than multiplication?
*/
component main {public [in1]} = Multiply();
