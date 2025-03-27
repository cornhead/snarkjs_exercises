pragma circom 2.1.9; // specify compiler version

// circomlib already includes the isEqual template
include "circomlib/circuits/comparators.circom";

// We use the Poseidon Hash Function to build a commitment scheme.
// Poseidon is suited for our purposes because it is "SNARK-friendly".
include "circomlib/circuits/poseidon.circom";

/*
    Task 1: Sum over N elements
    ---------------------------

    `Sum` is parametrized with the number of summands N.
    Input: an array of N field elements
    Output: their sum

    Hint:
        You can use a for-loop (same syntax as in JS)
        or you can do it recursively
*/
template Sum(N) {
    signal input in[N];
    signal output out;

    ===START SOLUTION: recursive===
    if (N == 0){
        out <== 0;
    }
    else{
        component S = Sum(N-1);
        for (var i = 0; i < N-1; i += 1){
            S.in[i] <== in[i];
        }

        out <== S.out + in[N-1];
    }
    ===END SOLUTION===
    ===START SOLUTION: iterative===
    var sum = 0;
    for(var i = 0; i<N; i++){
       sum += in[i]; 
    }
    out <== sum;
    ===END SOLUTION===
}

/*
    Task 2: IsInSet
    ---------------

    `IsInSet` is parametrized with the size N of the set and the set itself (as array).
    Input: a field element
    Output: 1 if the field element is contained in the set, 0 otherwise
*/
template IsInSet (N, set){
    signal input in;
    signal output out;

    ===START SOLUTION: recursive===

    if (N == 0){
        out <== 0;
    } else{
        var set_minus_1[N-1];
        for (var i = 0; i < N-1; i += 1){
            set_minus_1[i] = set[i];
        }

        component iis = IsInSet(N-1, set_minus_1);
        iis.in <== in;

        component ie = IsEqual();
        ie.in[0] <== in;
        ie.in[1] <== set[N-1];

        out <== iis.out + ie.out;
    }
    ===END SOLUTION===
    ===START SOLUTION: iterative===
    var found = 0;
    component isEqual[N];
    for(var i = 0; i < N; i++){
        isEqual[i] = IsEqual();
        isEqual[i].in[0] <== in;
        isEqual[i].in[1] <== set[i];
        found += isEqual[i].out;
    }
    out <== found;
    // if in is in the set twice, I return 2.
    ===END SOLUTION===
}

/*
    Task 3: Check Colors
    --------------------

    `Mastermind_CheckColors` is parametrized, with the number `N_colors`
    of colors, the array `colors` containing field elements representing the colors
    and the length `len_sequence` of the input sequence. 
    Input: an array of field elements
    Output: 1 if all elements of the array represent valid colors, 0 otherwise

    Hint:
        Use the `Sum` and `IsInSet` templates from above.
*/
template Mastermind_CheckColors(N_colors, colors, len_sequence){
    signal input in[len_sequence];
    signal output out;

    ===START SOLUTION: recursive===

    component iis[len_sequence];
    component sum = Sum(len_sequence);

    for (var i = 0; i < len_sequence; i += 1){
        iis[i] = IsInSet(N_colors, colors);
        iis[i].in <== in[i];
        sum.in[i] <== iis[i].out;
    }

    component eq = IsEqual();
    eq.in[0] <== sum.out;
    eq.in[1] <== len_sequence;

    out <== eq.out;
    ===END SOLUTION===
    ===START SOLUTION: iterative===
    component isInSet[len_sequence];
    component sum = Sum(len_sequence);
    for(var i = 0; i < len_sequence; i++){
        isInSet[i] = IsInSet(N_colors, colors);
        isInSet[i].in <== in[i];
        sum.in[i] <== isInSet[i].out;
    }
    component eq = IsEqual();
    eq.in[0] <== sum.out;
    eq.in[1] <== len_sequence;
    out <== eq.out;
    ===END SOLUTION===
}

/*
    Task 4: Commit
    --------------

    `Commit` is parametrized with the length `len_sequence` of
    the color sequences which we want to commit to. 
    Input: a color sequence and a random field element.
    Output: a commitment to the sequence.

    The commitment is Computed as
        C := Poseidon( sequence || r)
*/
template Commit(len_sequence){
    signal input sequence[len_sequence];
    signal input r;
    signal output out;

    ===START SOLUTION: recursive===
    component P = Poseidon(len_sequence+1);
    
    for (var i = 0; i < len_sequence; i += 1){
        P.inputs[i] <== sequence[i];
    }

    P.inputs[len_sequence] <== r;

    out <== P.out;

    ===END SOLUTION===
    ===START SOLUTION: iterative===
    component pos = Poseidon(len_sequence + 1);
    for(var i = 0; i < len_sequence; i++){
        pos.inputs[i] <== sequence[i];
    }
    pos.inputs[len_sequence] <== r;
    out <== pos.out;
    ===END SOLUTION===
}

/*
    Task 5: Mastermind
    ------------------

    `Mastermind` is parametrized with the same parameters as `Mastermind_CheckColors`.
    Input: Two sequences, one as a guess, one as the correct solution
    Output: The number of positions at which the guess is equal to the solution. 
    Constraint: Additionally, it enforces that the values in the sequences correspond to valid colors.
*/
template Mastermind (N_colors, colors, len_sequence){
    signal input in_guess[len_sequence];
    signal input in_solution[len_sequence];
    signal input in_r;
    signal output out_C;
    signal output out_correct;

    // Check that sequences are valid colors
    // -------------------------------------

    ===START SOLUTION: recursive===
    component checkColors_guess = Mastermind_CheckColors(N_colors, colors, len_sequence);
    checkColors_guess.in <== in_guess;
    checkColors_guess.out === 1;

    component checkColors_solution = Mastermind_CheckColors(N_colors, colors, len_sequence);
    checkColors_solution.in <== in_solution;
    checkColors_solution.out === 1;
    ===END SOLUTION===
    ===START SOLUTION: iterative===
    component checkColors_guess = Mastermind_CheckColors(N_colors, colors, len_sequence);
    checkColors_guess.in <== in_guess;
    checkColors_guess.out === 1;

    component checkColors_solution = Mastermind_CheckColors(N_colors, colors, len_sequence);
    checkColors_solution.in <== in_solution;
    checkColors_solution.out === 1;
    ===END SOLUTION===

    // Verifying/Computing Commitment
    // ------------------------------

    ===START SOLUTION: recursive===
    component Com = Commit(len_sequence);
    Com.sequence <== in_solution;
    Com.r <== in_r;
    out_C <== Com.out;
    ===END SOLUTION===
    ===START SOLUTION: iterative===
    component Com = Commit(len_sequence);
    Com.sequence <== in_solution;
    Com.r <== in_r;
    out_C <== Com.out;
    ===END SOLUTION===

    // Compute Number of Correct Positions
    // -----------------------------------

    ===START SOLUTION: recursive===
    component eq[len_sequence];
    component sum = Sum(len_sequence);
    for (var i = 0; i < len_sequence; i += 1){
        eq[i] = IsEqual();
        eq[i].in[0] <== in_guess[i];
        eq[i].in[1] <== in_solution[i];
        sum.in[i] <== eq[i].out;
    }

    out_correct <== sum.out;
    ===END SOLUTION===
    ===START SOLUTION: iterative===
    component eq[len_sequence];
    component sum = Sum(len_sequence);
    for (var i = 0; i < len_sequence; i += 1){
        eq[i] = IsEqual();
        eq[i].in[0] <== in_guess[i];
        eq[i].in[1] <== in_solution[i];
        sum.in[i] <== eq[i].out;
    }

    out_correct <== sum.out;
    ===END SOLUTION===
}

component main {public [in_guess]} = Mastermind(4, [1,2,3,4], 5);
