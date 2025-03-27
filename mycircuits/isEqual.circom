pragma circom 2.1.9;

/*
    IsZero takes a field element as input.
    It returns 1 if the input is 0
    and 0 if it is anything else.
    Source: https://github.com/iden3/circomlib/blob/master/circuits/comparators.circom
*/
template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}

/*
    IsEqual takes an array of two field elements
    and outputs 1 if they are equal and 0 otherwise.
*/
template IsEqual() {
    signal input in[2];
    signal output out;

    ===START SOLUTION===
    component iszero = IsZero();
    iszero.in <== in[0] - in[1];

    out <== iszero.out;
    ===END SOLUTION===
}

/*
    We will want to use this file as a library
    so we don't specify a main component, but
    if you want to create proofs for IsEqual anyway,
    then uncomment the line below.
*/
// component main {public [in]} = IsEqual();
