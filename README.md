# Replication materials for a computational exploration of extremist political speech on Twitter

Author: Shuyi Yang

# Twitter scraping

Using the keywords paraphrased from questions determining politial identifications in the [World's Smartest Political Quiz](https://www.theadvocates.org/quiz/) by Advocates for Self-government, including Covid-19, 2020 Presidential Election, Gun Violence, gender issues, immigration, drug issues, tax, and healthcare. The Tweept search query in the [scraper](https://github.com/PAHADRIANUS/sm_extremism_shuyi_yang/blob/main/scripts/1.%20Tweets%20scraping.ipynb) returnsm the first 100k English spearking mathched results and summarize into datasets of each topic.

# Generationg of extremism identifiers

- Sentiment and moral values are generated in python: the former is the [SentimentDetector](https://nlp.johnsnowlabs.com/docs/en/annotators#sentimentdetector) package  to pick up the negative score, and the latter is the term frequency of words based on the [Moral Foundations Dictionary](https://moralfoundations.org/wp-content/uploads/files/downloads/moral%20foundations%20dictionary.dic).

- The profile score is generated using a R script based on packages provied by Pablo Babera in the project [Twitter Ideology](https://github.com/pablobarbera/twitter_ideology).

# Preparation for Amazon Mechanical Turk survey 

The scraper further draws a random sample (N=200) from the collected dataset and removes any ASCII code in the texts (mostly emojis in the tweets), which are not readable in the mturk file uploader. The [result](https://github.com/PAHADRIANUS/sm_extremism_shuyi_yang/blob/main/datafiles/Batch_results.csv) is returned at the end of the crowd-sourcing process. The Mturk score is generated by relabelling different categories the to a range from -1 to 1 and taking the average of the workers.

# The analysis
In the [analysis](https://github.com/PAHADRIANUS/sm_extremism_shuyi_yang/blob/main/scripts/6.%20Analyses.ipynb), the mturk dataset is first treated to find the accuracy of the identifiers in predicting human-labeled extremism as well as correlations among them. Then using the summed whole dataset, regressions only using each identifier as well as one using all three at once are done. Further exploration is done to see how the sentiment score works in each topic's subset.

