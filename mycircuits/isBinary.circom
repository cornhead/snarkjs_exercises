pragma circom 2.1.9;

include "./isEqual.circom";

/*
    IsBinary takes a field element as input.
    It returns 1 if the input is binary (either 0 or 1)
    and 0 if it is anything else.
*/
template IsBinary() {
    signal input in;
    signal output out;

    ===START SOLUTION===
    component is0 = IsEqual();
    is0.in[0] <== in;
    is0.in[1] <== 0;

    component is1 = IsEqual();
    is1.in[0] <== in;
    is1.in[1] <== 1;

    out <== is0.out + is1.out;
    ===END SOLUTION===
}

/*
    We will want to use this file as a library
    so we don't specify a main component, but
    if you want to create proofs for IsBinary anyway,
    then uncomment the line below.
*/
// component main {public [in]} = IsBinary();
