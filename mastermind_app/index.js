#! /usr/bin/env node

// needed because app is of type 'module' 
import { createRequire } from "module";
const require = createRequire(import.meta.url);

import { program }  from 'commander';
import chalk from 'chalk';
import storage from 'node-persist';

const snarkjs = require("snarkjs");
import fs from 'fs';

const len_sequence = 5;
const n_colors = 4;
const max_r = 21888242871839275222246405745257275088548364400416034343698204186575808495617; // order of the bn128 curve

const wasm_file = "../mycircuits/mastermind_js/mastermind.wasm";

storage.initSync();

program.version("1.0.0").description("App for playing provably secure Mastermind");

async function set_zkey_file(file_path) {
    storage.setItem('zkey_file', file_path);

    console.log( "Setting zkey file to " + file_path);
    console.log( chalk.green("Success"));
}

async function set_vkey_file(file_path) {
    storage.setItem('vkey_file', file_path);

    console.log( "Setting vkey file to " + file_path);
    console.log( chalk.green("Success"));
}

async function init_game(){
    var zkey_file = await storage.getItem('zkey_file');
    if (zkey_file == undefined){
        console.log(chalk.red("Error:") + "You first have to set a zkey file.");
        process.exit(1);
    }

    // Sample a random `color_sequence`
    // (Colors are in set {1,2,3,4})
    // --------------------------------
    
    ===START SOLUTION===
    var color_sequence = [];
    for (let i = 0; i < len_sequence; i++){
        var color = Math.floor(Math.random() * n_colors) + 1;
        color_sequence.push(color);
    }
    ===END SOLUTION===

    await storage.setItem('color_sequence', color_sequence);

    // Sample a random element `r` from Z_q (q = `max_r`)
    // ------------------------------------

    ===START SOLUTION===
    var r = Math.floor(Math.random() * max_r);
    ===END SOLUTION===

    await storage.setItem('commitment_r', r);


    // Compute a dummy proof on input
    //     in_guess = [1, 1, 1, 1, ...]
    //     in_solution = color_sequence
    //     in_r = r
    // --------------------------------

    ===START SOLUTION===
    var input_json = {
        "in_guess": Array(len_sequence).fill(1),
        "in_solution": color_sequence,
        "in_r": r
    };

    const { proof, publicSignals } = await snarkjs.groth16.fullProve( input_json, wasm_file, zkey_file);
    ===END SOLUTION===


    // Read the commitment from the public signals generated together with the proof
    // -----------------------------------------------------------------------------

    ===START SOLUTION===
    var commitment = publicSignals[0];
    ===END SOLUTION===

    console.log(chalk.green("Color Sequence: ") + color_sequence);
    console.log(chalk.green("Commitment: ") + commitment);
    console.log(chalk.green("Success"));

    process.exit(0);
}

async function compute_proof(guess){
    var zkey_file = await storage.getItem('zkey_file');
    if (zkey_file == undefined){
        console.log(chalk.red("Error: ") + "You first have to set a zkey file.");
        process.exit(1);
    }

    if (guess.length != len_sequence){
        console.log(chalk.red("Error: ") + "Length of guess has to be " + len_sequence +  ". Got length " + guess.length + ".");
        process.exit(1);
    }

    var solution = await storage.getItem('color_sequence');
    var r = await storage.getItem('commitment_r');

    // Compute a proof on input
    //     in_guess = guess
    //     in_solution = solution
    //     in_r = r
    // --------------------------

    ===START SOLUTION===
    var input_json = {
        "in_guess": guess,
        "in_solution": solution,
        "in_r": r
    };

    const { proof, publicSignals } = await snarkjs.groth16.fullProve( input_json, wasm_file, zkey_file);
    ===END SOLUTION===

    var proof_str = JSON.stringify(proof, null, null);
    var public_signals_str = JSON.stringify(publicSignals, null, null);

    console.log(chalk.green("Proof String:\n") + proof_str);
    console.log(chalk.green("Public Signals:\n") + public_signals_str);
    console.log(chalk.green("Success"));

    process.exit(0);
}

async function verify(proof_str, public_signals_str){
    var vkey_file = await storage.getItem('vkey_file');
    if (vkey_file == undefined){
        console.log(chalk.red("Error: ") + "You first have to set a vkey file.");
        process.exit(1);
    }

    var proof = JSON.parse(proof_str);
    var publicSignals = JSON.parse(public_signals_str);

    var vkey_path = await storage.getItem("vkey_file");
    const vKey = JSON.parse(fs.readFileSync(vkey_path));

    // Verify the proof using `vKey`, `publicSignals` and `proof`
    // ----------------------------------------------------------
    
    ===START SOLUTION===
    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
    ===END SOLUTION===

    if (res === true) {
        console.log(chalk.green("Verification OK"));
        console.log(chalk.green("Number of correct positions: ") + publicSignals[1]);
        console.log(chalk.green("Commitment: ") + publicSignals[0]);
        console.log(chalk.yellow("(Don't forget to check that the commitment didn't change.)"));
        process.exit(0);
    } else {
        console.log(chalk.red("Invalid proof"));
        process.exit(1);
    }

}

program
    .command('set_zkey_file <file>')
    .description('Takes a path to the zkey file (circuit specific)')
    .action((file) => set_zkey_file(file))

program
    .command('set_vkey_file <file>')
    .description('Takes a path to the verification key file (circuit specific)')
    .action((file) => set_vkey_file(file))

program
    .command('init')
    .description('Initializes the game by setting the random color sequence and committing to it.')
    .action(() => init_game())

program
    .command('compute_proof <guess...>')
    .description('')
    .action((guess) => compute_proof(guess))

program
    .command('verify <proof> <publicSignals>')
    .description('takes a proof and public signals als stringified JSON objects and verifies the SNARK')
    .action((proof, publicSignals) => verify(proof, publicSignals))

program.parse()
