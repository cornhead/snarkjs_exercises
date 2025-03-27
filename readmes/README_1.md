# Zero-Knowledge Proofs: Circom/SnarkJS Part I

## TL;DR

Download `snarkjs_part_1.zip` from the Moodle and extract it. Then execute the following commands:

```
docker load < snarkjs.1.1.0.dockerimage
docker-compose run snarkjs
```

and then proceed to complete the given template files and generate proofs using snarkJS.

## Introduction

Over the course of multiple exercise sessions, we aim to guide you towards a fun application of zkSNARKs. "zkSNARK" stands for zero-knowledge succinct non-interactive arguments of knowledge. While zkSNARKs will be explored in more detail later in the course, it's sufficient for now to know that they are very efficient zero-knowledge proof systems.

Modern zkSNARKs (Groth16, PlonK, etc.) work over arithmetic circuits to define the statement-witness relation. In practical applications, these circuits are very large and complex, making them difficult to construct manually. To handle this complexity, we use a higher-level languages for their specification, similar to hardware description languages like VHDL or Verilog.

In this exercise, we will use the [Circom](https://github.com/iden3/circom) compiler to specify circuits. Later on, we may use the [snarkJS](https://github.com/iden3/snarkjs) library to set up, create, and verify SNARKs for these circuit relations.

If you prefer, you can follow the installation guides in the GitHub repositories (linked above) to install the required dependencies and tools. However, this can be time-consuming and has caused issues in previous years. To save time and simplify the process, we have created a Docker image for you.

Your first task is to set up this Docker container (or alternatively, install Circom and snarkJS locally).

## Setting Up the snarkJS Docker Container

**Note**: Depending on your Docker installation, you might need to run Docker commands with root privileges. For example, you may need to use `sudo docker images` instead of `docker images`.

0. Prerequisites:
    To create and run Docker containers, ensure you have [Docker](https://www.docker.com/get-started/) installed. We will also use [Docker-Compose](https://docs.docker.com/compose/) to automate the container setup process.     
    Visit the Moodle course and download `snarkjs_part_1.zip`.
1. Make sure you have the `compose.yml` file and the `snarkjs:1.1.0` Docker image.
2. To import the Docker image, run the following command:

     ```
     docker load < snarkjs.1.1.0.dockerimage
     ```
      
     Afterwards, verify the image by running `docker images`. You should see an image called `snarkjs:1.1.0`.
     
     (If there only is a new image called `<None>`, take the ID (or hash value) that was output by `docker load` and run `docker tag <ID> snarkjs:1.1.0`)

3. Make sure you have the `mycircuits` directory. It contains the circom template files. 
    This directory will be mounted to an identically named directory inside the Docker container. This allows you to edit files on your host machine while accessing them from the container. The container also has permission to write to this directory on your host. 

    If you want to rename this directory, update the corresponding entry in the `compose.yml` file.

4. Setup is now complete.

## Using the snarkJS Docker Container

To interact with the snarkJS Docker container, start the container by running:

```
docker-compose run snarkjs
```

This will create and start the container, opening an interactive shell. If you accidentally close the container, you can restart it by running `docker-compose start snarkjs`. This command won’t create a fresh container but will reopen the existing one.

To ensure that snarkJS is set up correctly, run:

```
snarkjs --help
```

inside the container. This checks that snarkJS is working without errors.

You can now create and edit circuit files in the `mycircuits` directory on your host. These files should be immediately accessible from within the container.

Once your circuit file is ready, return to the container’s shell to interact with snarkJS.

## Roadmap for this Exercise Session

1. Set up the Docker container and verify everything is working.
2. Complete the `tiny_multiplication.circom` file and compile it.
3. Follow the [snarkJS README](https://github.com/iden3/snarkjs/blob/master/README.md) to set up a powers-of-tau ceremony. In parallel, proceed with the following:
4. Complete and compile the `isEqual.circom` file.
5. Complete and compile the `isBinary.circom` file.
6. Complete and compile the `isBinaryRepr.circom` file.
7. If time allows, design a circuit to verify that the challenger in the board game [Mastermind](https://en.wikipedia.org/wiki/Mastermind_%28board_game%29) is not cheating.

**Resources:**
The following resources might help you solve the tasks:
- [Circom Documentation](https://docs.circom.io/circom-language/signals/)
- [snarkJS README](https://github.com/iden3/snarkjs/blob/master/README.md)

**Hint:**
There also is a directory called `mycircuits_solutions`. If you get stuck with one task, let the solution inspire you and move on to the next task.

## Free Bonus Content for Interested Students

- Arithmetization with QAPs: Arithmetization is the process of compiling a set of constraints into an arithmetic program over which we can construct SNARKs. Here is a blog post by Vitalik Buterin (the Ethereum God) on QAPs: [QAPs: From Zero to Hero](https://medium.com/@VitalikButerin/quadratic-arithmetic-programs-from-zero-to-hero-f6d558cea649)

- Powers-of-Tau: Every SNARK requires a **trusted** setup. If the setup is malicious, all hope for security is lost. To strengthen the trust in the setup, we can perform a circuit-independent "Powers-of-Tau" ceremony to which everyone can contribute randomness. For more on Powers-of-Tau read [The Power of Tau or: How I Learned to Stop Worrying and Love the Setup](https://zeroknowledge.fm/the-power-of-tau-or-how-i-learned-to-stop-worrying-and-love-the-setup/)

- Groth16: In today's exercise you will probably have used the Groth16 SNARK. In a seminal paper from 2016, Jens Groth proposed this construction. With a proof length of only 3 group elements, Groth16 has the shortest proof length even up to day. In fact, it is still an open research problem whether SNARKs of proof length 2 are even feasible. Here is the paper that came to be known as Groth16: [On the Size of Pairing-based Non-interactive Arguments](https://eprint.iacr.org/2016/260)

- DarkForest: DarkForest is an online game that uses SNARKs designed with circom and snarkJS. To get an insight into how these tools are used in a larger application, here are two blog posts by the developers: [Zero-Knowledge Proofs for Engineers: Introduction](https://blog.zkga.me/intro-to-zksnarks), [ZKPs for Engineers: A look at the Dark Forest ZKPs](https://blog.zkga.me/df-init-circuit)

## Cleanup After the Exercise

Since we will continue working on this project, please do not delete the Docker containers or files you’ve created. You’ll need them later.

If you must reclaim disk space, follow these steps:

1. Run `docker ps -a` to list all Docker containers created during the session.
2. Remove the unwanted containers using:

    ```
    docker container rm <ID1> <ID2> ...
    ```

3. Once all containers based on an image are removed, you can also remove the image. To do so, run `docker images` to find the unwanted image, and then run:

    ```
    docker image rm <ID>
    ```

**Have fun playing around with snarkJS! :D**

Author: Konrad Klier, Oct 2024
