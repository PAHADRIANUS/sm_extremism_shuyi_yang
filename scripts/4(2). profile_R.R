toInstall <- c("ggplot2", "scales", "R2WinBUGS", "devtools", "yaml", "httr", "RJSONIO")
install.packages(toInstall, repos = "http://cran.r-project.org")
install.packages("scales", dependencies=TRUE)

library(remotes)
install_github("pablobarbera/twitter_ideology/pkg/tweetscores")

library(tweetscores)

my_oauth <- list(consumer_key = "b2JxrB0DUD4LVyWSBX3w3NZtW",
                 consumer_secret = "Mg3Bnh4XnSygbNl8xT8WUHm4YmXKuHsEiSvVxmYr2B4ZcnblAx",
                 access_token="967977225017491456-DLVxD8S3O4zL6aXQYTOaLZzDvu50FiH",
                 access_token_secret = "3txbp9in1XML6TsuYhfOzOlXT5elZJmY7lZhc1RYyqWYD")

user <- "marisol_ochoa19"

friends <- getFriends(screen_name=user, oauth=my_oauth)
results <- estimateIdeology2(user, friends)
results

setwd("C:/Users/PAHADRIANUS")
valid_df <- read.csv(file = 'valid.csv')


valid_df['pscore'] <- NA
for(i in 194:nrow(valid_df)) {   
   print(i)
   temp <- valid_df[i,16]
   try(valid_df[i,17] <- estimateIdeology2(temp, getFriends(screen_name=temp, oauth=my_oauth)))
   print(temp)
}
rm(i)

valid_df[1,17]

user <- "p_barbera"
print(estimateIdeology2(user, getFriends(screen_name=user, oauth=my_oauth)))

write.csv(valid_df, "mturk_0.csv", row.names=TRUE)
