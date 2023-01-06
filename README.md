# teaching

Here you can find educational material I've written. My publications are [here](https://scholar.google.co.uk/citations?user=OJ6t2UwAAAAJ), my home page is [here](https://www.bdi.ox.ac.uk/Team/c-wymant), I occassionally tweet [here](https://twitter.com/ChrisWymant).

### Basic maths, with public health and epidemiology examples:
* A [quiz](basic_maths/InductionQuiz.pdf) testing the topics covered, and the [answers](basic_maths/QuizAnswers.pdf)
* One set of [slides](basic_maths/ShortCourse_MathsRefresher2015_ChrisWymant.pdf) covering most of the material (the following slides go into a bit more detail)
* Basic manipulation of numbers - the [slides](basic_maths/Lecture1.pdf) for 2015 and prose-style [notes](basic_maths/Lecture1_2014.pdf) from 2014
* Inequalities, functions and units - [slides](basic_maths/Lecture2.pdf) for 2015, [solutions](basic_maths/Lecture2_solutions.pdf) to the problems, and prose-style [notes](basic_maths/Lecture2_2014.pdf) from 2014
* Probability parts [one](basic_maths/Lecture7_part1.pdf) and [two](basic_maths/Lecture7_part2.pdf)
* A bit of supplementary material about [calculus](basic_maths/PostXmas_Calculus.pdf) and [matrices](basic_maths/PostXmas_matrices.pdf)  

I wrote the above (for a Bachelors course, a masters course and 'the short course' for professionals) while employed by Imperial College London, who have a claim on copyright. Do not re-use this material.


### Inference / data analysis:
* Statistical Modelling (A very short introduction), [here](https://docs.google.com/document/d/1V2igitQVFnQRIWGupmmbA3GqvX8DgAeLI0taH36oJNI/edit?usp=sharing). A lecture for the University of Oxford Centre for Doctoral Training in Health Data Sciences. 
* Inferring things from quantitative data, or why it's better to think less about _doing things to data_, [here](other_topics/2021-09-29_Chris_InferenceOnly.pdf)
* The need for hierarchical models to infer things from naturally grouped data: [here](other_topics/2022-04-06_TrainingSession_Chris_HierarchicalModellingGroupedData.pdf).
Code for the example is the hierarchical model in the Stan section below.
* If you are using a Bayesian statistical model to explore some parameters numerically, while also analytically marginalising over some parameters (usually for computational efficiency), and you use a posterior predictive check for how well your model fits the data, a subtle point you can easily get wrong is described in detail [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/Stan_example_predicting_from_analytically_marginalised_params.html) (the underlying R markdown file is [here](other_topics/Stan_example_predicting_from_analytically_marginalised_params.Rmd)).

### The [Stan](https://mc-stan.org/) language for probabilistic programming (especially Bayesian inference):  
* A list of places I know of for learning about Stan, both generally and in the context of infectious disease epidemiology, [here](other_topics/stan_learning_resources.md)
* A decision tree for which block you should declare parameters in [here](other_topics/WhichBlockForParameters.png) 
* A simple example of inference on censored/truncated data, involving a likelihood with both probability density and probability mass, R code [here](other_topics/continuous_truncated_variable_mixed_likelihood_density_mass.R) and Stan code [here](other_topics/continuous_truncated_variable_mixed_likelihood_density_mass.stan)
* A simple example of a hierarchical/multi-level model, R code [here](other_topics/HierarchicalSchools.R) and Stan code [here](other_topics/HierarchicalSchools.stan)
* A simple example of the (non-trivial) problem of binary classification - getting the probability that each observation has come from either one process (a signal distribution) or another (a noise distribution) - working around Stan not supporting discrete parameters. R code [here](other_topics/estimate_binary_vector.R) and Stan code [here](other_topics/estimate_binary_vector.stan)
* The last bullet point in the 'Inference' section above has exampled Stan code incorporated in it

### Pathogen sequence analysis:
* Pathogen phylogenetic trees, and how to assemble viral genomes from genetic sequence data with shiver [here](other_topics/Wymant_Lecture1_shiver.pdf)
* Estimating who infected whom with phyloscanner [here](other_topics/Wymant_Lecture2_phyloscanner.pdf)
* A [webinar](https://www.youtube.com/watch?v=TR2a46vBwGY) in which I talk through a subset of the slides from the above two lectures
* A computational practical showing how to use phyloscanner is [here](https://drive.google.com/drive/folders/0BwygWUC73hnxbGtHSFpWdzYzVkk?resourcekey=0-Zjt4kVHja6Djo7qKsN3r5Q&usp=sharing). Being taught this practical was [apparently](https://www.krisp.org.za/blogs.php?id=48) "like receiving piano lessons from Beethoven;" YMMV
* An accessible summary of our discovery of the VB variant of HIV is [here](https://www.beehive.ox.ac.uk/hiv-lineage), and a webinar on the subject is [here](https://www.youtube.com/watch?v=hQ-M1MyXtHM). Virtually the same webinar but with an introduction in French is [here](https://www.youtube.com/watch?v=kpgNaiXCxfA).

### Coding in R:  
* A quick introduction to the tidyverse (basically just to the dplyr package and the pipe operator) [here](other_topics/tidyverse_quick_intro.md)
* more to come...

### Other bits and pieces

Advice on writing a scientific paper in academia [here](other_topics/advice_for_writing_a_scientific_paper.MD).

A [blog post](https://www.coronavirus-fraser-group.org/blog#8august2021) explaining our group's paper modelling the effectiveness of daily lateral flow testing as an alternative strategy for reducing transmission from the traced close contacts of SARS-CoV-2 index cases.

A [glossary](other_topics/Glossary_HIV.csv) of HIV terms (mainly at the molecular and cellular level) from when I first started working on HIV.

Here are some [bash commands](https://www.dropbox.com/s/65eyimir8aukxe6/CommonBashCommands.sh?dl=0)</a> (i.e. working with the terminal / command line) that I find helpful.

For experts I've also written summaries of some conferences:
* Epidemics8 in 2021 [here](https://twitter.com/ChrisWymant/status/1465775301972185088) 
* COVID-19: Advances and Remaining Challenges in 2021 [here](https://twitter.com/ChrisWymant/status/1443248100143927296)
* Virus Genomics and Evolution 2021 [here](https://twitter.com/ChrisWymant/status/1438178907438653441)
* Human Virus Dynamics and Evolution 2021 [here](https://twitter.com/ChrisWymant/status/1390733002754379784)
* Net Zero 2019 [here](https://twitter.com/ChrisWymant/status/1171361818847121408) 
* Oberwolfach (the maths of infectious diseases) 2018 [here](https://twitter.com/ChrisWymant/status/969205940623994881)
* Epidemics7 in 2017 [here](https://www.dropbox.com/s/y4iuz2tdwdrq7io/Epidemics2017.txt?dl=0)
* IAS 2017 [here](https://www.dropbox.com/s/w0uffmzcir8141s/IAS.txt?dl=0)
* Mathematical and Computational Evolutionary Biology 2016 [here](https://twitter.com/ChrisWymant/status/743852693047881728) 

Some explanations of things on twitter:
* On the harmful oversimplification of focussing only on the _fraction_ of SARS-CoV-2 infections that become severe, [here](https://twitter.com/ChrisWymant/status/1412436234845175812)
* Lockdown pros and cons [here](https://twitter.com/ChrisWymant/status/1321543816298614784)
* Our group's agent-based model of SARS-CoV-2 epidemics and interventions [here](https://twitter.com/ChrisWymant/status/1308751845997903881)
* Why science is easier than politics [here](https://twitter.com/ChrisWymant/status/1154710730526117889)
* A pet hate: academics leveraging/harnessing things left, right and centre instead of _using_ them [here](https://twitter.com/ChrisWymant/status/1082201811640086528)
* Really funny jokes about the command line [here](https://twitter.com/ChrisWymant/status/974329420180803584) and [here](https://twitter.com/ChrisWymant/status/950682089313259521)

Acknowledgement: I wrote the above while funded by ERC Advanced Grant PBDR-339251 and a Li Ka Shing Foundation grant, both awarded to [Christophe Fraser](https://www.bdi.ox.ac.uk/Team/christophe-fraser).

### Explanatory things that other people wrote that I recommend:
* Read [this](http://www.amazon.co.uk/The-Elements-Style-William-Strunk/dp/020530902X) if you write in English. Read [this](https://www.amazon.co.uk/Politics-English-Language-Penguin-Classics/dp/0141393068) if you write in order to make a point.
* Read [this](http://www.damtp.cam.ac.uk/user/tong/talks/talk.pdf) if you give talks.
* Read [this](https://doi.org/10.1371/journal.pcbi.1005510) if you're a scientist using a computer.
* Other people recommended these resources for learning to interact with your computer through the command line (a.k.a. the terminal a.k.a. the shell), which is very helpful for being able to use other people's computational scientific methods: [here](http://rik.smith-unna.com/command_line_bootcamp) [here](http://www.ee.surrey.ac.uk/Teaching/Unix) and [here](http://swcarpentry.github.io/shell-novice/)
* Other people recommended [this](http://happygitwithr.com/) for learning version control with Git (aimed at users of R but with more general applicability), which is invaluable for writing your own scientific methods.
* [This](http://detexify.kirelabs.org/classify.html) helps one remember obscure latex symbols.

### Finally some things I wrote while not funded by the grants mentioned above:
* A talk on climate change and how we're fucking up the planet and nature generally [here](other_topics/GroupMeeting_ClimateStuff_BoxesWithinBoxes.pdf)
* A summary of experts advocating taking to the streets for climate action [here](https://twitter.com/ChrisWymant/status/1180468223889874945). Here's me doing so with [students](https://twitter.com/ChrisWymant/status/1106564598629613569), [doctors](https://twitter.com/ChrisWymant/status/1175086736130609152) and other [scientists](https://twitter.com/ChrisWymant/status/1183110115207106561), and happily talking to the [police](https://twitter.com/ChrisWymant/status/1118083365134131201)
* Suggestions for good twitter accounts to follow on climate, from when I used to have the bandwidth for that, [here](https://twitter.com/ChrisWymant/status/1225491802574217220)
* An explanation of the "5-1" system of service receive for volleyball [here](other_topics/The_5-1_explained.pdf)
* Really you made it this far? Maybe you'll like my lovingly curated [playlists](https://tinyurl.com/SpotifyChrisW) or vegan recipe [meta-analyses](https://docs.google.com/spreadsheets/d/1f3MYycHjTvrQagO-raRTsJtIC8fnsa1SVfEqTxF1HGk/edit?usp=sharing)
