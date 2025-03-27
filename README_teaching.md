# Circom/SnarkJS Parts I-III -- Notes on Teaching

This README is meant for whoever teaches the practical exercise sessions on Circom and SnarkJS.

The document explains how to update the teaching material and collects some experiences from the first iteration of the session.

## Updating the Exercise Material

### Tools

The directory in which this README is contained contains all files that are necessary for the development of the exercise material and some tools which help with the export process.
The tools contain:

#### Solution Parser

The python script `solution_parser.py` reads from `stdin` and writes to `stdout`. The input is supposed to be code (e.g. circom or JS code). The script looks for the lines `===START SOLUTION===` and `===END SOLUTION===` and replaces everything between (including the delimiter lines) either with a To-Do comment or the solution, depending on the parameter.

This allows you to write one file and derive the assignment and solution files from it. (This saves a lot of yank-pasting.) Multiple alternative solutions can be specified by something like `===START SOLUTION: <my solution identifier>===` and then calling the script with an additional parameter `<my solution identifier>`.

#### Export
The shell script `export.sh` can be used to export the assignments. It takes one parameter indicating which part of the exercise (1,2,3) should be exported. The script then fetches all required files, compiles the README from markdown to HTML, derives assignment and solution code files using the solution parser, packs everything into one directory and zips it. The resulting file is ready to be uploaded to Moodle.

To compile the README from markdown to HTML, the script uses Pandoc. If, for some reason, you can't install Pandoc, you can resort to the online tool [Dillinger](https://dillinger.io/).


### Updating the Lecture Slides

The lecture slides are written in Libre Office Impress. This has the advantage over PowerPoint that it is free software (not like free beer but like free speech). When opening the open-document-format file in PowerPoint, there might be issues.

The main font is Yanone Kaffeesatz. Again, this available under some creative-commons license. You might have to download it to edit the slides properly. (Actually, Yanone Kaffeesatz is one of the most wide-spread open fonts.)

### Updating the Dockerfile/Dockerimage

After having made changes to the `Dockerfile`, please rebuild the docker image using `docker build -t snarkjs:x.x.x .` where the x's are the version number. Then re-export the image with `docker save -o snarkjs.x.x.x.dockerimage snarkjs:x.x.x`. This way, students can import the image instead of building it, which only takes a few seconds instead of ~15 mins.

This does not apply to `compose.yml`. Since this file behaves more like a script, there is no need to rebuild anything after making changes to it.

Please also check that the image is exported together with its tag. Otherwise students have to set it manually, which is not difficult but might cause confusion.


## Notes on Teaching

Here I collect my experience from this year's exercise session.

### Part I

Presenting the slides and giving an introduction to SNARKs and to the tools took me ~10 mins.

The only real issue during the exercises was the following: after exporting and importing the docker image, its tag was lost. This was easy to fix with `docker tag <Image ID> snarkjs:x.x.x`. This should be fixed in the upcoming years by also exporting the tag with the image (which should already be the case with the command given above).

Within the given 45 mins., all students managed to setup docker and do the tiny multiplication circuit. Almost everone managed the isEqual task. Some managed the isBinary task. Only one person thought it had also solved the isBinaryRepr task.

Two common questions were the following:

*How do I execute the circuit*: When the only thing we are interested in is the output of the computation, then computig the witness can be seen as "executing" circuit. We can then just use the output value. However, in most applications, the actual computation is done "outside" and the circuit/SNARK is only used to verify some properties of the computation. This question will probably be answered in more detail in Part II, when students should actually build a small application with SNARKs.

*How do I validate the circuit*: While the SNARK guarantees that the circuit does the thing right, how do we know that the circuit does the right thing? We don't really have a satisfying answer to that but the question is extremely important. In a [ZK Bug Tracker](https://github.com/0xPARC/zk-bug-tracker) on Github, a lot of the discovered bugs actually concern the circuit. Furthermore, ZCash had a problem with its circuit which caused a vulnerability. (Jonathan was not able to find the article anymore). So yea, the question is very relevant.

### Part II

(Taught by Sebastian Faller.)

- There were about 7 or 8 students.
- Two of them finished the task (by working together.)
- Most people did not team up, because they were already sitting alone

Questions that were asked:
- How do you use circom-test? (Only the name was mentioned on the slides)
- How do you get a proof from your circom circuit?

Ideas for next time:
- Gently "force" students to team up. I only said they could. But maybe we should rather say they have to.
- Add a short summary of the snarkjs commands to the readme that one needs to execute to actually create a proof (it says how to do it in the snarkjs readme but some students didn't read that carefully enough.)

### Part III

Sadly, there was only one single student. This is probably because there was a graded homework still going on and an algo-lab exam.

The student had to generate a setup first, but still managed to solve the tasks in time.

One idea, which I was not able to implement, was to extend SnarkJS with a simulator for Groth16. This way, we (the teaching team) would be able to always win the game when playing against students and, thus, teach them the importance of the honesty of the setup. If you're interested in finishing the implementation, send me an email: `kklier@student.ethz.ch`.

Author: Konrad Klier, Oct 2024
