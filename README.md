# teaching

Here you can find educational/explanatory material written by me (Chris Wymant), pitched at various levels from student to researcher.
My publications are [here](https://scholar.google.co.uk/citations?user=OJ6t2UwAAAAJ), my home page is [here](https://www.bdi.ox.ac.uk/Team/c-wymant), I occassionally post on Bluesky [here](https://bsky.app/profile/chriswymant.bsky.social).

There's lots of material below organised by topic.
One thing to highlight is my [advice](other_topics/advice_for_writing_a_scientific_paper.MD) for writing papers in academic science.
I think that improvement there is low-hanging fruit: communicating our work is an important and undervalued part of our work.

Here are video recordings of talks I've given on various topics:
* pathogen sequence analysis [here](https://www.youtube.com/watch?v=TR2a46vBwGY),
* our discovery of a highly virulent variant of HIV [here](https://www.youtube.com/watch?v=hQ-M1MyXtHM) (or with an introduction in French [here](https://www.youtube.com/watch?v=kpgNaiXCxfA)),
* our proposal and evaluation of digital contact tracing for SARS-CoV-2 [here](https://lshtm.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=6859462a-ff69-4877-8c01-afe100dfe883),
* the interplay of proximity and duration of exposure for SARS-CoV-2 transmission [here](https://www.youtube.com/watch?v=wfBiF7rmr7E).

Here are audio recordings:
* discussing our discovery of a highly virulent variant of HIV with BBC World Service [here](https://www.bbc.co.uk/programmes/w3ct1l4z), starting 1 min 11 secs into the programme 
* discussing infectious disease epidemiology and statistical modelling on the Learn Bayesian Statistics podcast, in a live edition recorded at StanCon 24, [here](https://player.captivate.fm/episode/8f372809-3905-4110-8e1b-2f5ca1f95b33) (see other podcast listening options [here](https://learnbayesstats.com/))

Below, materials are organised by topic.

### Basic maths, with public health and epidemiology examples:
* A [quiz](basic_maths/InductionQuiz.pdf) testing the topics covered, and the [answers](basic_maths/QuizAnswers.pdf)
* One set of [slides](basic_maths/ShortCourse_MathsRefresher2015_ChrisWymant.pdf) covering most of the material (the following slides go into a bit more detail)
* Basic manipulation of numbers - the [slides](basic_maths/Lecture1.pdf) for 2015 and prose-style [notes](basic_maths/Lecture1_2014.pdf) from 2014
* Inequalities, functions and units - [slides](basic_maths/Lecture2.pdf) for 2015, [solutions](basic_maths/Lecture2_solutions.pdf) to the problems, and prose-style [notes](basic_maths/Lecture2_2014.pdf) from 2014
* Probability parts [one](basic_maths/Lecture7_part1.pdf) and [two](basic_maths/Lecture7_part2.pdf)
* A bit of supplementary material about [calculus](basic_maths/PostXmas_Calculus.pdf) and [matrices](basic_maths/PostXmas_matrices.pdf)  

I wrote the above (for a Bachelors course, a masters course and 'the short course' for professionals) while employed by Imperial College London who claim  copyright in such circumstances, therefore this material should not be re-used.


### Inference / data analysis:
* Statistical Modelling (A very short introduction), [here](https://docs.google.com/document/d/1V2igitQVFnQRIWGupmmbA3GqvX8DgAeLI0taH36oJNI/edit?usp=sharing). A 2023 lecture for the University of Oxford Centre for Doctoral Training in Health Data Sciences. Code as a worked solution to the two parts of the practical is [here](other_topics/practical_poisson.R) and [here](other_topics/practical_normal.R)
* For my 2025 lecture on that same course I focussed on what mathematical modelling and statistical modelling are at a high level, the basic laws of probability, a little about counterfactuals, and using random-effects (hierarchical/multi-level) models to describe CD4 cell decline during HIV infection. Lecture slides [here](other_topics/health_data_science_cdt_stats_2025.pdf), practical [here](https://docs.google.com/document/d/1buYJB5s9NMz8XkN03mmGziGp598Mo90X1hdXa40qgxE/edit?usp=sharing), worked solutions to practical exercises are [here](other_topics/practical_poisson.R) and [here](other_topics/practical_normal.R) for 1, [here](other_topics/Wymant_practical_CFR.R) and [here](other_topics/Wymant_practical_CFR.stan) for 2 using [this](other_topics/Wymant_practical_CFR_WHO-COVID-19-global-data.csv) WHO data, [here](other_topics/Wymant_practical_CD4decline_lineage.R) and [here](other_topics/Wymant_practical_CD4decline_lineage.stan) for 3. (For completeness, the 2024 slides are [here](other_topics/health_data_science_cdt_stats_2024.pdf) but the 2025 ones are a slight improvement.)
* Inferring things from quantitative data, or why it's better to think less about _doing things to data_, [here](other_topics/2021-09-29_Chris_InferenceOnly.pdf)
* The need for hierarchical models to infer things from naturally grouped data: [here](other_topics/2022-04-06_TrainingSession_Chris_HierarchicalModellingGroupedData.pdf).
Code for the example is the hierarchical model in the Stan section below.
* Some basic basics about causal inference [here](other_topics/causal_inference_wymant.pdf)
* Kind of inference, though mostly an exercise in R plotting code: how to plot survival curves for Kaplain-Meier estimators and the Cox proportional hazards model [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/survival_cox_hazards_plotting_example.html) (the underlying R markdown file is [here](other_topics/survival_cox_hazards_plotting_example.Rmd)). 
* Why I prefer Bayesianism to Frequentism for inference [here](other_topics/2022-12-12_Chris_FrequentistAndOrBayesian.pdf)
* Gelman proposed a useful [folk theorem](https://statmodeling.stat.columbia.edu/2008/05/13/the_folk_theore/) of statistical computing. A minor proposed addition to this: _If your statistical model is failing to infer the known parameters values used to simulate data, it's 50:50 that the problem is with your simulation rather than your statistical model._  (I usually forget this and focus on debugging my inference code, 50% of the time unnessecarily.) 
* If you are using a Bayesian statistical model to explore some parameters numerically, while also analytically marginalising over some parameters (usually for computational efficiency), and you use a posterior predictive check for how well your model fits the data, a subtle point you can easily get wrong is described in detail [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/Stan_example_predicting_from_analytically_marginalised_params.html) (the underlying R markdown file is [here](other_topics/Stan_example_predicting_from_analytically_marginalised_params.Rmd)).

### The [Stan](https://mc-stan.org/) language for probabilistic programming (especially Bayesian inference):  
* A list of places I know of for learning about Stan, both generally and in the context of infectious disease epidemiology, [here](other_topics/stan_learning_resources.md)
* A decision tree for which block you should declare parameters in [here](other_topics/WhichBlockForParameters.png) 
* Censored data: a simple example of inference involving a likelihood with both probability density and probability mass, R code [here](other_topics/continuous_truncated_variable_mixed_likelihood_density_mass.R) and Stan code [here](other_topics/continuous_truncated_variable_mixed_likelihood_density_mass.stan)
* Censored data: a more involved example of estimating the generating process for two correlated variables, either or both of which may be censored. The likelihood contains a mixture of probability density functions, and one- and two-dimensional integrals of these. Worked example [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/Stan_example_singly_or_doubly_censored_data.html) (the underlying R markdown file is [here](other_topics/Stan_example_singly_or_doubly_censored_data.Rmd)). 
* When specifying uniform/range priors with the boundary of one prior depending on another parameter, e.g. $x\sim\text{Uniform}(0,1)$ and $y|x\sim\text{Uniform}(0,x)$, the way Stan behaves by default is probably not what you intended: explanation [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/Stan_example_dependent_uniform_priors.html) (the underlying R markdown file is [here](other_topics/Stan_example_dependent_uniform_priors.Rmd)).
* Hierarchical/multi-level modelling: a simple example with R code [here](other_topics/HierarchicalSchools.R) and Stan code [here](other_topics/HierarchicalSchools.stan)
* A similar example to the previous one, showing how a multi-level model for describing the difference between many groups does better than sequentially testing each group being different than the rest [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/Stan_example_hierarchical_model_false_positives.html) (the underlying R markdown file is [here](other_topics/Stan_example_hierarchical_model_false_positives.Rmd)).
* Probabilisitic classification: a simple example of classifying observations as having come from either one process or another ('signal' or 'noise') using a mixture model. R code [here](other_topics/estimate_binary_vector.R) and Stan code [here](other_topics/estimate_binary_vector.stan)
* Ragged panel data: an example of fitting simple linear slopes to panel data (longitudinal data for each of several units) that is ragged (different number of observations per unit), with unit-specific random effects that we analytically marginalise over is [here](https://htmlpreview.github.io/?https://github.com/ChrisHIV/teaching/blob/main/other_topics/Stan_example_ragged_panel_data_analytically_marginalised_params.html) (the underlying R markdown file is [here](other_topics/Stan_example_ragged_panel_data_analytically_marginalised_params.Rmd)).
* The last bullet point in the 'Inference' section above has Stan code examples incorporated in it

### Pathogen sequence analysis:
* Slides about pathogen phylogenetic trees, and how to assemble viral genomes from high-throughout ('next-generation') genetic sequence data with shiver [here](other_topics/Wymant_Lecture1_shiver.pdf) (see also the shiver publication [here](https://doi.org/10.1093/ve/vey007))
* Slides about estimating who infected whom with phyloscanner [here](other_topics/Wymant_Lecture2_phyloscanner.pdf) (see also the phyloscanner publication [here](https://doi.org/10.1093/molbev/msx304))
* A [webinar](https://www.youtube.com/watch?v=TR2a46vBwGY) in which I talk through a subset of the slides from the above two lectures
* A computational practical showing how to use phyloscanner is [here](https://drive.google.com/drive/folders/0BwygWUC73hnxbGtHSFpWdzYzVkk?resourcekey=0-Zjt4kVHja6Djo7qKsN3r5Q&usp=sharing). Being taught this practical was [apparently](https://www.krisp.org.za/blogs.php?id=48) "like receiving piano lessons from Beethoven;" YMMV
* An accessible summary of our discovery of the VB variant of HIV is [here](https://www.beehive.ox.ac.uk/hiv-lineage), and a webinar on the subject is [here](https://www.youtube.com/watch?v=hQ-M1MyXtHM). Virtually the same webinar but with an introduction in French is [here](https://www.youtube.com/watch?v=kpgNaiXCxfA).

### SARS-CoV-2 / COVID-19:
* Slides [here](other_topics/Wymant_DigitalContactTracing_2023-03-29_LSHTM_public.pdf) and a recorded webinar [here](https://lshtm.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=6859462a-ff69-4877-8c01-afe100dfe883) about two of our group's papers on digital contact tracing (our initial [proposal](https://doi.org/10.1126/science.abb6936) and our [evaluation](https://doi.org/10.1038/s41586-021-03606-z)).
* A recorded webinar [here](https://www.youtube.com/watch?v=wfBiF7rmr7E) about how transmission risk depends on the interplay between proximity and duration of exposure. I wrote a short summary [here](https://045.medsci.ox.ac.uk/risk_measurement) and a thread in our group twitter account [here](https://twitter.com/ChristoPhraser/status/1737513767733272914).
* A short summary of our paper on high-resolution real-time epidemic monitoring via digital contact tracing systems is [here](https://045.medsci.ox.ac.uk/monitoring/). I wrote a thread in our group twitter account [here](https://x.com/ChristoPhraser/status/1811725269788430543).
* A [blog post](https://045.medsci.ox.ac.uk/blog#8august2021) explaining our group's paper modelling the effectiveness of daily lateral flow testing as an alternative strategy for reducing transmission from the traced close contacts of index cases.

### Coding in R:  
* A quick introduction to the tidyverse (basically just to the dplyr package and the pipe operator) [here](other_topics/tidyverse_quick_intro.md)
* more to come...

### Summary notes I made about some conferences:
* Epidemics8 in 2021 [here](https://twitter.com/ChrisWymant/status/1465775301972185088) 
* COVID-19: Advances and Remaining Challenges in 2021 [here](https://twitter.com/ChrisWymant/status/1443248100143927296)
* Virus Genomics and Evolution 2021 [here](https://twitter.com/ChrisWymant/status/1438178907438653441)
* Human Virus Dynamics and Evolution 2021 [here](https://twitter.com/ChrisWymant/status/1390733002754379784)
* Net Zero 2019 [here](https://twitter.com/ChrisWymant/status/1171361818847121408) 
* Oberwolfach (the maths of infectious diseases) 2018 [here](https://twitter.com/ChrisWymant/status/969205940623994881)
* Epidemics7 in 2017 [here](https://www.dropbox.com/s/y4iuz2tdwdrq7io/Epidemics2017.txt?dl=0)
* IAS 2017 [here](https://www.dropbox.com/s/w0uffmzcir8141s/IAS.txt?dl=0)
* Mathematical and Computational Evolutionary Biology 2016 [here](https://twitter.com/ChrisWymant/status/743852693047881728) 

### Other bits and pieces

Advice on writing a scientific paper in academia [here](other_topics/advice_for_writing_a_scientific_paper.MD).

A [glossary](other_topics/Glossary_HIV.csv) of HIV terms (mainly at the molecular and cellular level) from when I first started working on HIV.

Here are some [bash commands](https://www.dropbox.com/s/65eyimir8aukxe6/CommonBashCommands.sh?dl=0)</a> (i.e. working with the terminal / command line) that I find helpful.

A simple example of changing an R-code for loop into parallelised command-line executions (e.g. for sending to a computational cluster), with a short discussion of the benefits of parallelising only partially instead of fully, is [here](other_topics/parellelising_an_R_code_loop_for_a_cluster.md).

A simple tip for handling responses to reviewers during peer review: as soon as you receive your reviews copy them all into a Google doc, put a differently formatted TODO between each separate point, then share this document with your coauthors. Replace the TODOs with your actual responses once you've addressed that comment. This is a handy way of tracking progress, noting things to remember, and discussing with coauthors how best to respond (use Google doc's comment feature and "@" people at specific places). Using this document even to read your your reviews for the first time (as opposed to reading the email they came in) means you can make a note of whatever first thoughts pop into your head. Example [here](https://docs.google.com/document/d/1lbm3UDjS3ne6WVl8h5sACTQMefunkV-VBx0Y_FqLGKc/edit?usp=sharing).

Some explanations of things on twitter:
* On the harmful oversimplification of focussing only on the _fraction_ of SARS-CoV-2 infections that become severe, [here](https://twitter.com/ChrisWymant/status/1412436234845175812)
* Lockdown pros and cons [here](https://twitter.com/ChrisWymant/status/1321543816298614784)
* Our group's agent-based model of SARS-CoV-2 epidemics and interventions [here](https://twitter.com/ChrisWymant/status/1308751845997903881)
* A summary of results obtained from that model [here](https://twitter.com/ChrisWymant/status/1250842199086059523) (summarising our report provided to NHSX [here](https://github.com/BDI-pathogens/covid-19_instant_tracing/blob/master/Report%20-%20Effective%20Configurations%20of%20a%20Digital%20Contact%20Tracing%20App.pdf))
* Why science is easier than politics [here](https://twitter.com/ChrisWymant/status/1154710730526117889)
* A pet hate: academics leveraging/harnessing things left, right and centre instead of _using_ them [here](https://twitter.com/ChrisWymant/status/1082201811640086528)
* Really funny jokes about the command line [here](https://twitter.com/ChrisWymant/status/974329420180803584) and [here](https://twitter.com/ChrisWymant/status/950682089313259521)

Acknowledgement: I wrote all the above materials while funded by ERC Advanced Grant PBDR-339251 and a Li Ka Shing Foundation grant, both awarded to [Christophe Fraser](https://www.bdi.ox.ac.uk/Team/christophe-fraser).

### Explanatory things that other people wrote that I recommend:
* Read Strunk and White if you write in English (it's online [here](http://www.jlakes.org/ch/web/The-elements-of-style.pdf)). Read [Politics and the English Language](https://www.amazon.co.uk/Politics-English-Language-Penguin-Classics/dp/0141393068) if you write in order to make a point; some highlights are [here](other_topics/politics_and_the_english_language_highlights.md).
* Read [this](http://www.damtp.cam.ac.uk/user/tong/talks/talk.pdf) if you give talks.
* Read [this](https://doi.org/10.1371/journal.pcbi.1005510) if you're a scientist using a computer.
* [Here](https://halllab2.sitehost.iu.edu/grad-student-resources.html) is a large collection of resources providing advice for graduate students, organised by topic
* Other people recommended these resources for learning to interact with your computer through the command line (a.k.a. the terminal a.k.a. the shell), which is very helpful for being able to use other people's computational scientific methods: [here](http://rik.smith-unna.com/command_line_bootcamp) [here](http://www.ee.surrey.ac.uk/Teaching/Unix) and [here](http://swcarpentry.github.io/shell-novice/)
* Other people recommended [this](http://happygitwithr.com/) for learning version control with Git (aimed at users of R but with more general applicability), which is invaluable for writing your own scientific methods.
* [This](http://detexify.kirelabs.org/classify.html) helps one remember obscure latex symbols.

### Finally some things I wrote while not funded by the grants mentioned above:
* A talk on climate change and how we're fucking up the planet and nature generally [here](other_topics/GroupMeeting_ClimateStuff_BoxesWithinBoxes.pdf)
* A summary of experts advocating taking to the streets for climate action [here](https://twitter.com/ChrisWymant/status/1180468223889874945). Here's me doing so with [students](https://twitter.com/ChrisWymant/status/1106564598629613569), [doctors](https://twitter.com/ChrisWymant/status/1175086736130609152) and other [scientists](https://twitter.com/ChrisWymant/status/1183110115207106561), and happily talking to the [police](https://twitter.com/ChrisWymant/status/1118083365134131201)
* Suggestions for good twitter accounts to follow on climate, from when I used to have the bandwidth for that, [here](https://twitter.com/ChrisWymant/status/1225491802574217220)
* An explanation of the "5-1" system of service receive for volleyball [here](other_topics/The_5-1_explained.pdf)
* Really you made it this far? Maybe you'll like my lovingly curated [playlists](https://tinyurl.com/SpotifyChrisW) or vegan recipe [meta-analyses](https://docs.google.com/spreadsheets/d/1f3MYycHjTvrQagO-raRTsJtIC8fnsa1SVfEqTxF1HGk/edit?usp=sharing)
