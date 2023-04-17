## Advice on writing a scientific paper (in academia)

### Use a question-driven approach

Start by getting as clear as you can in your head about what question your work addresses.
Anecdotally, I find a fairly common structure in talks (less so papers) by junior scientists is  
* An introduction to the general area of study,
* What you did, in detail,
* What the result of doing that was,
* Speculation as to why that might be of interest to the general area: which hypotheses the result (dis)favours.
That’s not a compelling structure, because as one follows, it’s less clear _why_ you’re doing what you’re doing.
**Finish your introduction with the specific question you attempted to answer, explaining why that question matters**.
That means people are either hooked from the start, or they realise as early as possible that what you’ve done isn’t relevant for them and they can save their mental bandwidth for something else.
It also means people know where you're trying to get to as they follow your journey for getting there, which is much clearer.

The question you present is not necessarily the same question that you actually set out to answer at the start of your project: there's nothing wrong with finding some result and then realising afterwards that it answers someone else’s important question. And you might want to revisit the question you started with depending what you found, e.g. restrict the scope if you realise there are problems with generalisability.

I feel (I am perhaps biased) that an exception to this question-focussed approach is when you discover a thing that exists (or existed) that wasn’t known to exist, e.g. a [viral variant](https://www.beehive.ox.ac.uk/hiv-lineage) with certain properties, or a volcano, or an ancient language. There’s not necessarily an obvious question preceding such findings. One could try to shoehorn any finding into this exception, e.g. “I discovered that there exists a statistically significant correlation between variables x and y in my data,” but the fact that you could do something doesn't mean you should. Generally, people are interested in what you find in your data only to the extent that we can generalise from it to something bigger. Which means e.g. considering whether the data you started with was a good thing to start with for the question in hand. So it's better not to shoehorn but to challenge oneself to construct a question to which one’s findings provide a reasonable answer (such as does actionable thing X cause desirable outcome Y).

I've seen people tweet that scientific work should always be testing a hypothesis, to avoid people fishing in the data for signals for which explanations are later constructed, but which are actually just noise, worsening the reproducibility crisis.
I saw one reply providing the counter-example of counting species in a given area: there is no hypothesis being tested.
Both sides here have a point.
Focussing too narrowly on 'testing' hypotheses comes from a frequentist statistics tradition of rejecting or failing to reject null hypotheses.
As Andrew Gelman pithily [summarises](https://statmodeling.stat.columbia.edu/2018/06/17/bayesians-are-frequentists/): "I do model checking to test the model that I am fitting, usually not to test a straw-man null hypothesis.
I already know my model is false, so I don’t pat myself on the back for finding problems with the fit (thus “rejecting” the model); rather, when I find problems with fit, this motivates improvement to the model."
Scientific work should aim to discriminate between different hypotheses (which could be continuous rather than discrete, for example corresponding to the true value of a continuous parameter such as the spatial density of species).
This is similar to saying we should start from a question: we should be seeing how the evidence discriminates between different possible answers (and knowing that one answer provides a poor explanation of the data does not mean we should reject it - we need to also show that a different plausible answer provides a good explanation of the data).

### Structure your writing at the level of paragraphs

Plan what you are going to write, and make sure you understand what you have already written, at the level of paragraphs.
Each paragraph should
* collect sentences that are related to each other with an easily definable theme
* avoid repeating something from a previous paragraph (unless this is intentional for emphasis, especially between Discussion and Results),
* come in a coherent flow of ideas from one paragraph to the next.

To ensure that your writing is structured at the level of paragraphs, maintain a list of very short bullet points saying what the main point of each paragraph is.
You'll need to keep that list in sync with the actual paragraphs as you write them - switching between modifying the structure and modifying the actual text until the two things match each other and the plan matches the structure you want.
Depending on what mood you're currently in, it can be better to plan your structure (big-picture thinking) or craft text to match your desired structure (fleshing out details).
Keep that plan visible when you share your draft with co-authors: it's helpful for them to see at a glance what your structure is supposed to be, instead of them each needing to figure it out.
If you start the writing process by creating a draft of this list, that’s a great point at which to get early feedback from co-authors, because the whole point and structure of the paper is clear at a glance and can easily be turned into something different with minimal wasted writing.

As an example of the previous paragraph, I might start by writing this paragraph structure for my Discussion section:  
1. summary: what we did, what we found, how we interpret that finding  
2. refer to previous studies  
3. limitation: non-representative data limits generalisability  
4. limitation: demonstrated correlation not causation  
5. outlook, what should (some) people do now in light of this result
  
I might show this to a coauthor who can tell me immediately that our data is much more representative that I thought, so there's no need to write paragraph 4.
Then I might start to write the actual paragraphs and realise there's so much to say on intepretation that a whole paragraph would be better, in which we should talk about novelty, because interpretation and novelty both help people understand why they should care about this result.
So I'd revise my structure to

1. summary of what we did and what we found  
2. why care: how we interpret that finding and why it's novel  
3. refer to previous studies  
4. limitation: correlation not causation  
5. outlook, what should (some) people do now in light of this result

(Variations on the above structures generally work well for the results section of a results-focussed paper; adjustment is needed for a methods-focussed paper.) 

Another example: I might take a section of my paper that I already wrote without an explicit structure accompanying it, and then try to write such a list to match what I've already written.
As a result I might identify some problems with my existing structure, e.g. one paragraph without an easily identifiable theme, or one point repeated in multiple paragraphs when those sentences would be better collected together.
I would then move around sentences (or delete them) until the text has a sensible paragraph structure.

Having an explicit written list for what the paragraph structure is will help you and your coauthors write text with good structure.
Of course you won't include that list with the actual final text, and so your broad readership won't see quite so easily what the paragraph structure is.
To help them, try to make the opening sentence of each paragraph indicate what the rest of the rest of the paragraph will be about.

The Introduction section should have a roughly funnel structure from broad to specific, ending with an explanation of what you set out to do in this paper: “Here, we...“. I read somewhere, and agree, that the funnel should be such that the closing bit about your work should feel inevitable - you’ve drawn the reader towards your question feeling like the natural thing to work on. In the best case you have provided something completely novel, in which case immediately before your “Here, we...” is an explanation of how no one has looked at this problem before. Normally your result is more incremental, and you can say that uncertainty remains on this particular aspect of a phenomenon, or that the problem is so important that further studies are useful to validate existing results. An example funnel:
* one paragraph on the English SARS-CoV-2 epidemic
* one paragraph on contact tracing
* one paragraph on digital contact tracing
* one paragraph on previous studies of digital contact tracing, mentioning absence of empirical estimates of epidemiological impact
* “Here, we empirically estimated the epidemiological impact of the NHS COVID-19 app. We do this by [very brief summary]”

### Other considerations

CLARITY CLARITY CLARITY.
Write to be understood as clearly as possible.
Do not use your writing style to try to make the work sound more impressive.
If impressing people is your aim, have something impressive to say (in which case being as clear as possible helps your aim); if you don't, using an impressive-sounding style makes you a salesperson for a crappy car - it's not a good look.
_Use_ methods and _analyse_ data: don't leverage them or harness them.
_A methodology_ is a class of methods - are you sure that's what you mean rather than _a method_?
A single method can still have aspects of it that can be adjusted in different applications; this doesn't mean we should promote it to being a class of methods.
_Methodologies_ can almost always be replaced by _methods_.

Writing the Methods section is the easiest thing to do: it’s just describing what you’ve done.
For that reason I’ve heard it recommended as a starting point - to get your foot into in the writing process.
However, grappling with the construction of a narrative for your work may make you realise that part of what you’ve done is unnecessary, or that something you haven’t done is necessary, or that it would be better to split into several papers.
So I think it’s better to work on the big picture before diving into easy details.

What I look for in every presentation or paper is what should people do differently as a result of what you’ve found. For a methods paper, it’s normally to use that method instead of the best previous alternative for this particular application. For applied results papers, it might be that doctors/society should consider using more X to get more of desirable outcome Y, or at least that further study should establish your X-Y link more concretely and explore feasibility, cost-effectiveness etc. For theoretical results papers, it might be that other researchers should investigate your new idea because it has the potential to help us understand something which is manifestly important. For a convincing negative result - enough data for statistical power, appropriate kind of data & method for accuracy and generalisability - the implication might be that people should stop pursuing an avenue previously thought to be promising. There are lots of possibilities for how your finding might influence some people, but if you struggle to think concretely of who and how, it’s worth having a frank conversation with yourself about whether your paper was a good use of your time. No use crying over spilt milk of course, but one can strive to not keep spilling milk forever. (This was a big factor in why I stopped working on theoretical particle physics.)

Clearly establish and then stick to a one-to-one mapping between [things] and [the names we use to refer to those things].
i.e. avoid using different terms to refer to the same thing, and avoid using the same term to mean different things.
A one-to-one map makes it as clear as possible for the reader and frees up their concentration for more important things.
Expanding on this, repetition - in the sense of repeating the decision you make about how to write a particular thing (not repeating the same point) - helps the reader to see the connections between different places in your writing.
(Ah, it's a different name here, so it's a different thing; ah, it's the same name here, so it's the same thing.)
This goes for structure as well as choice of names.
Compare:  
_Authors A used method a and found result X [A]. Result Y was obtained [b] leveraging methodology b. Employing c, C et al [C] demonstrated Z._  
with something like  
_A et al used method a and found X [A]. B et al used method b and found Y [B]. C et al used method c and found Z [C]._  
The latter is certainly drier but easier to parse.
Recall that coercing data into [tidy format](https://vita.had.co.nz/papers/tidy-data.pdf) (rectangular, one row per observation, one column per aspect of the observation i.e. per variable) makes the data clearer as well as easier to operate on (though obviously some data is naturally of a different structure, such as trees).
In the same way, coercing two or more similar sentences (or clauses within a sentence) into a common structure helps to clarify both their similarities and their differences for lower mental effort.

Tenses: I like past tense for Methods and Results, present (or future) tense for Discussion.
Paraphrasing an explanation I was given: mathematicians and physicists favour the present tense for results because there is a feel of timelessness to the findings.
However, in biomedical research, different findings are fairly often in some tension with each other; a single finding is just a higher level of a single observation within a study.  
Methods: We *regressed* y against x.  
Results: We *found* a correlation.  
Discussion: We *interpret* this as evidence that x *causes* y, given the assumed absense of confounders.  
And use the active tense for what you did (*We did X*); recommendations to use the passive tense (*X was done*) to sound more netural are so last century.
I read somewhere that the active tense reminds the reader that the steps taken were made by fallible humans, not by some idealised notion of the scientific process.
I agree.
There can also be genuine ambiguity about who did the thing that was done if you're also talking about previous work.

Finally, a point of grammar which comes up all the time in technical writing: hyphenation of modifiers.
When we write A B C where C is a noun and A and B are modifiers, we hypenate A-B if and only if A and B work together to form a single composite modifier, the most common example being that A modifies B.
We don't hyphenate if and only if A and B separately modify C.
e.g. a strange smelling cheese is a cheese that is strange and possesses the ability to smell, whereas a strange-smelling cheese is probably what one means.
I like the recommendation of the Chicago Manual of Style to break this rule when A is an adverb that ends in "ly", because ending in "ly" means it's obviously an adverb and adverbs only modify adjectives or verbs, never nouns, so there's no ambiguity about what A is modifying.
e.g. a "significantly improved method" is just as clear and more stylish than a "significantly-improved method".
Hyphenation is for when the modifiers precede the noun, not when they follow it.
e.g. that cheese is strange smelling, not strange-smelling.
