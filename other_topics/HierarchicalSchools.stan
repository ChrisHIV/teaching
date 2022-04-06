data {
  
  int<lower = 1> num_schools;
  int<lower = num_schools> num_students;
  int<lower = 1, upper = num_schools> school[num_students];
  real<lower = 0, upper = 100> grade[num_students];
  // convenient redundancy of specifying per-school information once per student:
  int<lower = 0, upper = 1> treated[num_students]; 
  
  // Something that is not actually data but should be kept fixed over one
  // whole round of inference: a boolean switch for whether we sample from the
  // posterior or the prior, to see how and how much the data are updating our
  // beliefs about the parameters and the kind of data they generate.
  // 0 for prior, 1 for posterior:
  int<lower = 0, upper = 1> get_posterior_not_prior; 

}

parameters {
  
  // Parameters for which we explicitly chose values in order to define the 
  // data-generation process at the highest level of the hierarchy (i.e. most
  // fundamental):
  real<lower = 0,    upper = 100> stddev_students;
  real<lower = 0,    upper = 100> stddev_schools;
  real<lower = 0,    upper = 100> grade_untreated_mean;
  real<lower = -100, upper = 100> treatment_effect;
  
  // Parameters that, in our simulation, were derived from one or more of the 
  // above parameters i.e. are at a lower level of the hierarchy. NB in reality
  // these are not observed, so are just parameters of the overall process
  // that we try to estimate, like the more fundamental ones.
  real<lower = -100, upper = 100> school_effects[num_schools];

}

// Quantities that are determined by the parameters can be declared and
// calculated either in a transformed parameters block or in the model block.
// If the former, Stan includes their values in its output, and they can be 
// reused in the generated quantities block later if you like.
transformed parameters {
  real grade_expected[num_students];
  for (student in 1:num_students) {
    grade_expected[student] =
      grade_untreated_mean +
      school_effects[school[student]] +
      treated[student] * treatment_effect;
  }
}

model {

  // Declarations of any intermediate variables needed for the calculation must 
  // come first in the model block. None currently, but if grade_expected were
  // calculated here instead of in the transformed parameters block, its 
  // declaration would have to come first in this block.

  // First, priors: how likely are the current values of the parameters given
  // our a priori expectations.
  // Any parameters for which a prior is not explicitly stated is implicitly
  // taken to be uniform between its lower and upper bounds (which is an
  // improper prior if not both lower and upper bounds were specified).
  school_effects ~ normal(0, stddev_schools);
  
  // NB an alterative way of doing the above, which is mathematically identical 
  // but allows more efficient exploration of the parameter space, would be to
  // define school_effects_standardised (say) in the parameters block which has
  // a prior of normal(0, 1), and then to simply multiply that vector by
  // stddev_schools to give the actual school effects that enter into the
  // calculation below for expected grades. I don't do that here just to keep
  // the example as simple as possible.
  
  // Second, the likelihood: how likely is the data given these parameters.
  if (get_posterior_not_prior) {
    grade ~ normal(grade_expected, stddev_students);
  }
  
}

// Generated quantities block: intended for things like simulating new data
generated quantities {
  real grade_simulated[num_students];
  grade_simulated = normal_rng(grade_expected, stddev_students);
}
