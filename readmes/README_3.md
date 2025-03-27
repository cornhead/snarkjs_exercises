# Zero-Knowledge Proofs: Circom/SnarkJS Part III

## TL;DR

1. Download the files from Moodle.
2. Move `mastermind_app/` to your local files.
3. Follow the instructions in `index.js` to complete the app.

## Introduction

Welcome to the third part of the Circom/SnarkJS exercises!

In the previous parts, you have familiarized yourself with the circom language and designed a verification circuit to play the boardgame Mastermind in a provably secure way. In this part, to wrap everything up, you are going to create a NodeJS app for the command line to actually play the game. (The app only runs locally. If you want to send proofs over the network, you still have to do so manually.)

Luckily, SnarkJS has a very good interface for Javascript. A minimal working example of a Node app with SnarkJS can also be found in the [Readme](https://github.com/iden3/snarkjs).

Playing the game with the app will look as follows:

- The challenger will set its previously generated proving key (the setup); the guesser will set its verification key.
- The challenger will initialize the game. This includes the following steps:
    - Sample a random color sequence
    - Sample a random element from `Z_q` for the commitment
    - Compute the commitment (e.g. by computing a proof and using the commitment from the public values)
- Then, the challenger can send the commitment to the guesser.
- The guesser makes his guess and sends it to the challenger.
- The challenger computes a proof, using the guess as input, and sends the proof and the public signals to the guesser.
- The guesser verifies the proof and checks that the commitment is the same as the initial one.

Your task will be to implement these steps. However, we do not send anything over the network. Instead, the app runs locally and you can send the proofs via mail, messenger or Moodle, if you like.

## Your Tasks

If you want to, get together in groups of two or three and split up the tasks between you.

First, make sure that you have a setup ready for the mastermind circuit (zkey and verification key). If not, consult the Readme on how to create this. This will take some time, so if you haven't done so already, generate the setup in parallel to your other tasks. Also, make sure that you have generated a `mastermind.wasm` file.

Make sure that you have downloaded the exercise files from Moodle. It should include a directory called `mastermind_app/`. Copy it into your local files next to your `mycircuits/` directory. You can edit and run the app on your host system. If you already have compiled the circuit and generated a setup, there is no need to use the Docker container in this part of the exercise.

Open the file `index.js`. It is the only file you need to concern yourself with. Complete the given snippets marked with a todo. The comments should guide you through it.

**Resources:**
The following resources might help you solve the tasks:

- [snarkJS README](https://github.com/iden3/snarkjs/blob/master/README.md)

**Hint:**
There also is a file called `index_solution.js`. If you get stuck with one task, let the solution inspire you and move on to the next task, rather than losing too much time.

## After You Are Done -- Playing the Game

Grab a friend and start playing. An outline of the intended use can be found in the introduction.

You might need to adjust the constant `wasm_file` to point to your `mastermind.wasm` file.

To install all dependencies, run `npm install`. Then, you can use `npx mastermind` to run the app or `npm link` to "install" it.

Have fun playing the game! :D

## Free Bonus Content for Interested Students

- We focused on Circom/SnarkJS because it is easy to learn and easy to integrate into JS apps. However, this is only one of many SNARK frameworks. If you want to, you can have a look at the following other frameworks:
    - [Arkworks](https://github.com/arkworks-rs): A SNARK ecosystem in Rust. More involved but also more professional and very performant.
    - [ZoKrates](https://zokrates.github.io/introduction.html): SNARKs over Ethereum (but also otherwise).
    - Or have a look at [ZK Languages](https://github.com/microbecode/zk-languages), which contains examples for many other SNARK languages/frameworks.

- So far our app runs only locally. If you want to, it should not be too difficult to implement a server that forwards the proofs. Then, you can also play remotely.

- If you are interested in current developments in the ZK landscape beyond what we covered in the course, have a look at the [ZK Podcast](https://zeroknowledge.fm/).

- There is still a workshop and an adjacent CTF going on for a few days. If you want to hack around with ZK proof systems, have a look at this years edition of [ZK Hack](https://zkhack.dev/).

Author: Konrad Klier, Dec 2024
