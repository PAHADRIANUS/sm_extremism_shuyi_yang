# MACS 30123 Final Project: Measuring the power of extremist language in Social Media

Please refer to the following descriptions for the final project of MACS 30123 Large Scale Computing for Social Science.

Author: Shuyi Yang

# Social Science Questions

Living in an era of rapid political polarization, one can observe that political figures and media posts with more instigating speeches are more likely to attract supporters and viewers. Despite defeat of the US's Trump in 2020, the polarizing tendency persisted across the globe, with far-right or far-left groups gaining more grounds in many countries; though Macron has secured his reelection, the victory was a precarious one with significantly fewer supporters compared to 2017 and his party is likely to lose majority in parliament. The project aims to identify the mechanism of such gatherings: a) statistically confirm that more radical speech wins more viewers/upvotes/comments on social media, and thus more biased people are more outspoken; b) model the growth of an extremist group and then use the model to predict the future developments. The situations outside the US can provide some background knowledge, but for familiarity I should focus on the US environment.


# Methods and limitations

The project use random sampled tweets on specificly selected trending topics that typically reflects political identities, based on [World's Smartest Political Quiz](https://www.theadvocates.org/quiz/) by Advocates for Self-government, including Covid-19 (#covid19), 2020 Presidential Election (#2020election, election2020), Gun Violence (gun violence, #NRA), gender issues (#feminism), immigration (immigration, deportation), drug issues (drug addicts, drug dealers), tax (tax cuts, tax the rich), and healthcare (#healthcare).The tweets' texts are scraped along with their Likes and Retweet counts. The data are gathered and treated with John Snow Labs' provided [SentimentDetector](https://nlp.johnsnowlabs.com/docs/en/annotators#sentimentdetector) model to produce regression variables.

One should take note in advance that the effects demonstrated by the project could be mechanically weaker than actual effects: since the turmoil and contention circumventing the 2020 Presidential Election and subsequent 2021 Capitol riots, social media, especially Twitter, has signigcantly tightened control over spread of right-wing speeches, including banning Trump himself from using his once frequently used Twitter account. It is obvious that right-wing users and posts are somewhat suppressed and contained, but nevertheless their influences are far from dwindling.

Another issue is that due to findings in a CMU study, it can be observed that in fact ultra left and right wings are sometimes mirrors of each other, speaking extremist languages alike. The project currently only discern sentiments and needed to be upgraded with trained models on political spectrum reflecting languages to be able to tell the difference. For the time being, it could easily mistake aggressive liberals for rights and produce quite some errors. 


# Seriel Computation Bottlenecks and solution

- Scraping bottleneck: the methods still relies on Twitter API to return tweepy search query results, meaning that it is unavoidbly capped on these data transmitting processes. The solution is have the scraping stages, once debugged locally, run on AWS environment with multiple notebook clusters based on multiple EC2 instances. The scraped results are directly passed to be stored in my designated S3 location s3://right-wing-speech-tweet-test1, with the convenience of running within the AWS environment. In addition, a particularly lagging stage in the pipline is turning tweepy query results to pandas dataframes; the process is accelerated by making the whole scraping script run with PySpark.

- Language processing: Gemsim's Word2vec functions were considered but since using PySpark can make the whole design anchored entirely on AWS, it is swapped with PySpark NLP. Admittedly, using Gemsim to train a NLP model myself could be more accurate; using a given model from Spark NLP wins a lot in terms of speed.

# Structure of Project
- Scrape Tweets, collect them as csv files and then upload them to AWS S3 bucket: [scrape_store.ipynb](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/scrape_store.ipynb)
- Dask to assemble the scattered scraping results and making general visualizations: [Dask_collect_and_visualization.ipynb](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/Dask_collect_and_visualization.ipynb)
- Spark NLP setup using the SentimentDetector models training data, lemmas and dictionary: [sparknlp_model_training.ipynb](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/sparknlp_model_training.ipynb)
- Variable transformations and implement the Spark results to train the model: [pyspark_ml.ipynb](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/pyspark_ml.ipynb)


# Data
All data used in the notebooks can be found at AWS S3 bucket [s3://right-wing-speech-tweet-test1](s3://right-wing-speech-tweet-test1).

The collection is based on the following topics with respective Twitter trends for search queries:

Covid-19(#covid19), 2020 Presidential Election(#2020election, election2020), Gun Violence(gun violence, #NRA), gender issues(#feminism), immigration(immigration, deportation), drug issues(drug addicts, drug dealers), tax(tax cuts, tax the rich), healthcare(#healthcare) 

- This displays a basic look on the relationships between tweet likes and retweets; their linear connections are pretty visible.
  - ![alt text](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/pic/v0.png?raw=true)

- This used holoviews to tailor the presentation; the tendencies are similar to the previous picture.
  - ![alt text](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/pic/v1.png?raw=true)

- A further look with parallel histograms.
  - ![alt text](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/pic/v2.png?raw=true)

- This view filtered the data to display verified Twitter users, in this case mostly celebrities, public figures or authorities, news outlets and influential third-party self-media. This is a much more concise sample, and as illustrated, the correlation is clearer.
  - ![alt text](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/pic/v3.png?raw=true)

# Result and Discussion

![alt text](https://github.com/lsc4ss-s22/final-project-far-right-speech/blob/main/pic/auc.png?raw=true)

This AUC is produced with the selected "verified" Twitter users sample and on a abridged NLP features, and thus appears somewhat ok, supporting the hypothesis of more sentimental languages would work. Currently if the whole gathered data is used with all features input, the machine learning methods, with multiple ones tried, won't compile a model. This is due to that in the large sample, a lot of tweets simply have very little likes or retweets, making them very poor observations for ML. It might be put forth that the whole project should be built on a selected sample of high-response tweets in the first place, but that would generate imbalanced dataset with biases. Well-known accounts are naturally inclined to certain languages usage to cater to a targeted audience. Further improvements on the project should be done still with tweets of minor responses, reflecting ordinary folks' level of social media, included.

# Reference

"Alt-Right, White Nationalist, Free Speech: The Far Right's Language Explained": https://www.npr.org/2017/06/04/531314097/alt-right-white-nationalist-free-speech-the-far-rights-language-explained

"The Left and the Right Speak Different Languages—Literally": https://www.wired.com/story/left-right-speak-different-languages-literally/

Advocates for Self-government quiz for political identities: https://www.theadvocates.org/quiz/

Hino, Airo and Fahey, Robert A., Representing the Twittersphere: Archiving a representative sample of Twitter data under resource constraints: https://pdf.sciencedirectassets.com/271677
                  
Can we detect conditioned variation in political speech? two kinds of discussion and types of conversation: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0246689

WE DON’T SPEAK THE SAME LANGUAGE: INTERPRETING POLARIZATION THROUGH MACHINE TRANSLATION, a CMU study: https://arxiv.org/pdf/2010.02339.pdf

Using administrative records and survey data to construct samples of Tweeters and Tweets. Public Opinion Quarterly: https://github.com/uchicago-computation-workshop/Spring2022/blob/master/05-05_Lazer/Lazer_1.pdf

Twitter API structrue: https://docs.tweepy.org/en/stable/api.html?highlight=search

Word2vec: https://radimrehurek.com/gensim/models/word2vec.html

Spark NLP:

- SentimentDetector: https://nlp.johnsnowlabs.com/docs/en/annotators#sentimentdetector

pyspark.ml:

- various models: https://spark.apache.org/docs/latest/ml-classification-regression.html

Dask dataframe: https://docs.dask.org/en/stable/dataframe.html
