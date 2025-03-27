pragma circom 2.1.9;

include "./isBinary_solution.circom";

/*
    IsBinaryRepr takes as input a field element `in`
    and an array `repr` of field elements of length `len`.
    It outputs 1 if `repr` is the correct binary
    representation of `in` and 0 otherwise.
    `repr[0]` is the MSB and `repr[len]` is the LSB.

    You are free to handle the case when `repr` is
    non-binary as you like. You can return 0 in this
    case, or simply not accept the input (by enforcing binarity).
*/
template IsBinaryRepr(len) {
    signal input in;
    signal input repr[len];
    signal output out;

    ===START SOLUTION===

    // enforce binarity of `repr`
    // --------------------------

    component isBinary[len];

    for (var i = 0; i < len; i += 1){
        isBinary[i] = IsBinary();
        isBinary[i].in <== repr[i];
        isBinary[i].out === 1;
    }

    // recompute field element from `repr`
    // -----------------------------------

    signal intermediate[len];
    intermediate[0] <== repr[0];

    for (var i = 1; i < len; i += 1){
        intermediate[i] <== 2*intermediate[i-1] + repr[i];
    }

    // compare results
    // ---------------

    component isEq = IsEqual();
    isEq.in[0] <== intermediate[len-1];
    isEq.in[1] <== in;

    out <== isEq.out;
    ===END SOLUTION===
}

/*
    IsBinaryRepr is the main component of our circuit.
    `ìn` is marked as public.
    That is, the prover proves that it knows the
    binary representation of `in` of length 8.
*/
component main {public [in]} = IsBinaryRepr(8);
