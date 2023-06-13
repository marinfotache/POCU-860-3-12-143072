############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################
###                       Scripturi R (in limba engleza)                 ###
############################################################################
###             Data Processing/Analysis/Science with R                  ###
############################################################################
###
############################################################################
###     13.a.2 The simplest (and more recent) way to build and compare   ###
###   classification models with `tidymodels`  (train-test, no tuning)   ### 
############################################################################
## last update: 2023-06-13

library(ranger)
library(tidyverse)
#library(broom)
library(tidymodels)
options(scipen = 999)

############################################################################
###            Download the necessary data sets for this script
############################################################################

# Please download the .zip file from address (https://github.com/marinfotache/POCU-860-3-12-143072/blob/main/7%20Importul%20și%20prelucrarea%20datelor%20în%20limbajul%20R/DataSets.zip)
# unload it, and set it as the default/working directory, ex:
setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R/DataSets')


#####################################################################
###                      Heart disease data set                   ###
#####################################################################
load('ml_datasets.RData')
rm(states)
glimpse(heart)

# check missing values 
any(is.na(heart))
# there are!!!

table(heart$AHD)

139 / (164 + 139)



##########################################################################
###                             Main split of the data                 ###
set.seed(1234)
splits   <- initial_split(heart, prop = 0.75, strata = AHD)
train_tbl <- training(splits)
test_tbl  <- testing(splits)



##########################################################################
###                        The recipe for data preparation             ###
### not all steps (in the following recipe) are really necessary 
### in this case, but in many other situations they are really useful
the_recipe <- recipe(AHD ~ ., data = train_tbl) %>%
    step_impute_knn(all_predictors(), neighbors = 3) %>%   # .missing values impoutation
    step_dummy(all_nominal(), -all_outcomes()) %>% # dummification of the predictors
    step_zv(all_predictors()) # this removes predictors with zero variance



#########################################################################
###                           Models Specification
lr_spec <- logistic_reg(mode = "classification") %>%
          set_engine("glm") 

rf_spec <- rand_forest() %>%
     set_engine("ranger") %>%
     set_mode("classification")



#########################################################################
###                   Assemble the workflows and fit the models

### the logistic regression model
set.seed(1234)
lr_fit <- workflow() %>%
    add_recipe(the_recipe) %>%
    add_model(lr_spec) %>%
    fit(data = train_tbl)

# examine the resulted tibble
lr_fit

lr_fit_summary <- broom::glance(lr_fit)

# raw coefficients
lr_fit_coefficients <- broom::tidy (lr_fit)
# ..or...
lr_fit_coefficients2 <- tidy(extract_fit_parsnip(lr_fit))


# exponentiated coefficients
lr_fit_coefficients_exp <- broom::tidy (lr_fit, exponentiate = TRUE)
# ..or...
coeffs_exp <- tidy(extract_fit_parsnip(lr_fit), exponentiate = TRUE)


## model predictions on the training set

# with `broom`, we get predictions as both classes and probabilities...
lr_fit_predictions <- broom::augment (lr_fit, new_data = train_tbl)
glimpse(lr_fit_predictions)

# with `predict`, by default we get the predictions as classes 
lr_fit_predictions2 <- bind_cols(train_tbl,
     predict (lr_fit, new_data = train_tbl))
glimpse(lr_fit_predictions2)

# to get the probabilities with `predict`...
lr_fit_predictions3 <- bind_cols(train_tbl,
     predict (lr_fit, new_data = train_tbl, type = "prob"))
glimpse(lr_fit_predictions3)




### the random forest classification model

set.seed(1234)
rf_fit <- workflow() %>%
    add_recipe(the_recipe) %>%
    add_model(rf_spec) %>%
    fit(data = train_tbl)

rf_fit

rf_fit_predictions <- broom::augment (rf_fit, new_data = train_tbl)
glimpse(rf_fit_predictions)
str(rf_fit_predictions)



#########################################################################
###                        Explore the results 

# Confusion matrix: 
conf_mat(lr_fit_predictions, truth = AHD, estimate = `.pred_class`)
conf_mat(rf_fit_predictions, truth = AHD, estimate = `.pred_class`)

# Accuracy
accuracy(lr_fit_predictions, truth = AHD, estimate = `.pred_class`)
accuracy(rf_fit_predictions, truth = AHD, estimate = `.pred_class`)

# Matthews correlation coefficient:
mcc(lr_fit_predictions, truth = AHD, estimate = `.pred_class`)
mcc(rf_fit_predictions, truth = AHD, estimate = `.pred_class`)

# F1 metric:
f_meas(lr_fit_predictions, truth = AHD, estimate = `.pred_class`)
f_meas(rf_fit_predictions, truth = AHD, estimate = `.pred_class`)



# ROC curve on the training set

# logistic regression model
lr_roc_curve <- roc_curve(lr_fit_predictions, truth = AHD, estimate = .pred_No)
lr_roc_curve
autoplot(lr_roc_curve)

lr_roc_auc <- roc_auc(lr_fit_predictions, truth = AHD, estimate = .pred_No)
lr_roc_auc


# random forest model
rf_roc_curve <- roc_curve(rf_fit_predictions, truth = AHD, estimate = .pred_No)
rf_roc_curve
autoplot(rf_roc_curve)

rf_roc_auc <- roc_auc(rf_fit_predictions, truth = AHD, estimate = .pred_No)
rf_roc_auc



#########################################################################
###     The moment of truth: model performance on the test data set

set.seed(1234)
test_lr <- broom::augment (lr_fit, new_data = test_tbl)
test_rf <- broom::augment (rf_fit, new_data = test_tbl)


# Confusion matrix: 
conf_mat(test_lr, truth = AHD, estimate = `.pred_class`)
conf_mat(test_rf, truth = AHD, estimate = `.pred_class`)

# Accuracy
accuracy(test_lr, truth = AHD, estimate = `.pred_class`)
accuracy(test_rf, truth = AHD, estimate = `.pred_class`)

# Matthews correlation coefficient:
mcc(test_lr, truth = AHD, estimate = `.pred_class`)
mcc(test_rf, truth = AHD, estimate = `.pred_class`)

# F1 metric:
f_meas(test_lr, truth = AHD, estimate = `.pred_class`)
f_meas(test_rf, truth = AHD, estimate = `.pred_class`)



# ROC curve on the test data set

# logistic regression model
lr_roc_curve_test <- roc_curve(test_lr, truth = AHD, estimate = .pred_No)
lr_roc_curve_test
autoplot(lr_roc_curve_test)

lr_roc_auc_test <- roc_auc(test_lr, truth = AHD, estimate = .pred_No)
lr_roc_auc_test

# random forest model
rf_roc_curve_test <- roc_curve(test_rf, truth = AHD, estimate = .pred_No)
rf_roc_curve_test
autoplot(rf_roc_curve_test)

rf_roc_auc_test <- roc_auc(test_rf, truth = AHD, estimate = .pred_No)
rf_roc_auc_test




#########################################################################
###                 Variable importance (for Random Forest)
#########################################################################

### Examine the regression coefficients

# raw coefficients
lr_fit_coefficients <- broom::tidy (lr_fit)
# ..or...
lr_fit_coefficients2 <- tidy(extract_fit_parsnip(lr_fit))


# exponentiated coefficients
lr_fit_coefficients_exp <- broom::tidy (lr_fit, exponentiate = TRUE)
# ..or...
coeffs_exp <- tidy(extract_fit_parsnip(lr_fit), exponentiate = TRUE)


lr_fit %>%
    tidy() %>%
    mutate(term = fct_reorder(term, estimate)) %>%
    ggplot(aes(estimate, term, fill = estimate > 0)) +
    geom_col() +
    theme(legend.position = "none")


coeffs_exp <- tidy(extract_fit_parsnip(lr_fit), exponentiate = TRUE)
coeffs_exp


library(vip)

set.seed(1234)
rf_imp_spec <- rf_spec %>%
    set_engine("ranger", importance = "permutation")

workflow() %>%
    add_recipe(the_recipe) %>%
    add_model(rf_imp_spec) %>%
    fit(train_tbl) %>%
    extract_fit_parsnip() %>%
    vip(aesthetics = list(alpha = 0.8, fill = "midnightblue"))

