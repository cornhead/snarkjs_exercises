# Zero-Knowledge Proofs: Circom/SnarkJS Part II

## TL;DR

1. Download the files from Moodle
2. Move `mastermind.circom` and `circomlib/` to `mycircuits/` from the previous part.
3. Follow the instructions in `mastermind.circom` to complete the circuit.

## Introduction

Welcome to the second part of the Circom/SnarkJS exercises!

In the previous part, you familiarized yourself with the Circom Language, created relatively small circuits and maybe even computed your first ever SNARK! In the second part we build on top of this and want to design a circuit for the board game "Mastermind".

If you're not familiar with Mastermind, you can find the rules on [Wikipedia](https://en.wikipedia.org/wiki/Mastermind_(board_game)). Essentially, it is a guessing game where one player comes up with a color sequence and places colored pegs behind a visual barrier accordingly. The other player has to guess it. After each guess, the player is told how many positions of its guess were correct, but not which ones! In the original game, the player would also learn how many positions of the guess have the correct color but are in an incorrect position. For simplicity, we omit this in our SNARK.

To securely play Mastermind with SNARKs, our circuit has to do three things:

Firstly, one player needs to compute a commitment to a color sequence. Our circuit needs to ensure that the prover knows the color sequence inside the commitment. All other computations are performed over this color sequence.

Secondly, the circuit should also have an input for the guess of the other player. It should then compute how many positions of the guess are correct and output the result without revealing anything more about the original sequence. This is the main part of the game.

Thirdly, the circuit has to check that the color sequences actually contains only valid colors. This is called a domain check. In the description of ZK protocols in the lecture, we omitted domain checks. In practice, however, they are very important and leaving them away creates room for attacks.

Your goal of this exercise session is to implement these three parts. Afterwards you should be able to play Mastermind with your friends via a messenger or e-mail.

## Your Tasks

If you want to, get together in groups of two or three and split up the tasks between you.

Make sure that you have downloaded the exercise files from Moodle. It should include the `mastermind.circom` template file, which contains all further task descriptions. Copy `mastermind.circom` and `circomlib/` into the `mycircuits/` directory from the first part so that you can use it inside the Docker container.

**Resources:**
The following resources might help you solve the tasks:
- [Circom Documentation](https://docs.circom.io/circom-language/signals/)
- [snarkJS README](https://github.com/iden3/snarkjs/blob/master/README.md)
- [CircomLib](https://github.com/iden3/circomlib/blob/master/circuits/poseidon.circom)

**Hint:**
There also is a file called `mastermind_solution.circom`. If you get stuck with one task, let the solution inspire you and move on to the next task, rather than losing too much time.

**Hint:**
If you've forgotten how to start your Docker container, try `docker-compose start snarkjs` or `docker-compose run snarkjs`. If you haven't set up your Docker container in the first place, please follow the instructions from the first part. You can find a self-contained `README.html` in the files from the first exercise part.
 
## After You Are Done -- Playing the Game

If you are done with the tasks and you are confident about the correctness of your circuit, it is time to start playing the game!

1. Find a friend or collegue you want to play with.
2. Agree on whose circuit to use. Prover and verifier need to work over the same circuit.
3. Agree on whose setup to use. In applications where security is important, you would re-run the Powers-of-Tau ceremony and make sure that everone contributes some randomness, but this takes a couple of minutes so it's easier to use the setup you created last time.
4. To give input to the circuit and compute SNARKs, create a file called `input.json` and follow the instructions in the [snarkJS README](https://github.com/iden3/snarkjs/blob/master/README.md) to create the proof. The prover starts by committing to the color sequence and sending it to the verifier. The verifier then repeatedly sends his guesses to the prover, the prover sends back the result and the SNARK to prove their correctness. The verifier only has to verify that the commitment of the prover always is the same so that he doesn't change the color sequence mid-game.

Have fun playing the game!

(If you get tired of writing json files and compiling proofs by hand, you can also develop a node app for that. SnarkJS has a very good interface. Let the example in its README inspire you.)

## Free Bonus Content for Interested Students

- In the first part, the question came up how we validate circuits. Validating circuits is very important but also difficult. In fact, a look at the [ZK Bug Tracker](https://github.com/0xPARC/zk-bug-tracker) shows how many vulnerabilities in ZK proof systems concern the circuit specification.
- For the commitment scheme, we used the Poseidon hash function. In contrast to more common hash functions like the ones from the SHA family, Poseidon was developed especially with ZK systems in mind, so it is a natural fit for our purpos: [Poseidon: A New Hash Function for Zero-Knowledge Proof Systems](https://eprint.iacr.org/2019/458)

Author: Konrad Klier, Nov 2024
