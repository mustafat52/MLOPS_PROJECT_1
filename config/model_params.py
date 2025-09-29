from scipy.stats import randint, uniform, loguniform

LIGHTGM_PARAMS = {
    'n_estimators' : randint(100,500),
    'max_depth' : randint(5,50),
    'learning_rate' : uniform(0.01,0.2),
    'num_leaves' : randint(20,100),
    'boosting_type' : ['gbdt', 'dart' ],
    'data_sample_strategy': ['goss', 'bagging'],
    
    # FIX: Add explicit control over L2 regularization
    # loguniform samples from a logarithmic range, which is standard for regularization.
    'reg_lambda': loguniform(1e-5, 1.0) 

}


RANDOM_SEARCH_PARAMS = {
    'n_iter' : 4,
    'cv' : 2,
    'n_jobs' : -1,
    'verbose' : 2,
    'random_state' : 42,
    'scoring' : 'accuracy'
}

