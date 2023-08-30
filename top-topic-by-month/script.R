library(data.table)
t = fread("/Users/henry_t/Desktop/perso/0_HackerNews_Summarisation/data/hn.csv")
dim(t)
t = t[Points >= 5, list(date=`Created At`, title=Title)]
nrow(t)
# 582026  for 10 points
# 890289  for 5 points

t[, year := lubridate::year(date)]
t[, month := lubridate::month(date)]

# get topic from each title
# ------
all_titles <- paste(t$title, collapse = " ")

# count all words
words <- unlist(strsplit(all_titles, " "))

# Count the number of words
word_counts <- data.table(word = words)[, .N, by = word]
word_counts = word_counts[order(-N)]

# 3. eliminate all uninformative words
# or rather select words
topics = c("Google", "Facebook", "Apple","Linux","Python","US","Amazon","Microsoft","U.S.","Javascript","Programming","Windows","Android","Internet","App","AI",
           "Bitcoin","China","iPhone","Rust","Github","Tesla","iOS","Game","Chrome","AWS","Firefox","Mac","Cloud","Ruby","Chinese","UK","C++","browser","Youtube","3D",
           "Lisp","Intel","Deep","Java","Uber","Covid-19","California","Elon","Video","Social","CSS","Store","website","Engine","Apps","NSA","Russian","Git","platform",
           "React","America","Rails","Musk","Startup","Startups","open-source","YC","framework","ChatGPT","OpenAI","HuggingFace","Russia","Ukraine","Ukrainian","Poutine",
           "Zelensky","Snowden","Ethereum","Clojure","Reddit","Raspberry","Node.js","Docker","HTML5","War","EU","Trump","Haskell","privacy","Covid","Privacy",
           "Ubuntu","Netflix","SQL","FBI","Kubernetes","PostgreSQL","Mozilla","Games","MIT","Yahoo","IBM","Neural","Black","Government","Combinator","Quantum",
           "CPU","GPU","AMD","NVidia","climate","SaaS","NASA","Crypto","Remote","Dropbox","Gmail","Wikipedia","SpaceX","Django","DNS","Japan","ads","Unix",
           "MacBook","nuclear","Emacs","Instagram","Street","Samsung","Swift","macOS","Analytics","Climate","Airbnb","Zuckerberg","Algorithms","Apache",
           "JSON","European","Slack","Postgres","DNA","coronavirus","GDPR","Alphabet","Craigslist","API","Bert","NLP","LinkedIn","Data",
           "Llama","LLMs","LLM","Stripe","FreeBSD","Meta","X","Twitter","Starlink","USA","GTA","GPT-4","GPT-3","GPT-5","ReST","SEC","X/Twitter",
           "Learning","Reinforcement","generative","cloud","TPU","AGPL","ETF","wind","electricity","energy","fuel","oil","BigQuery","language",
           "GitHub","Github","github","jQuery","FDIC","YouTube","Copilot","NumPy")


# Replace commas with spaces in the title column
t[, title := gsub(",", " ", title)]
t[, title := gsub("'", " ", title)]


# Function to keep only words from the topics list
keep_only_topics <- function(title, topics) {
  words <- unlist(strsplit(title, " "))
  filtered_words <- words[words %in% topics]
  new_title <- paste(filtered_words, collapse = " ")
  return(new_title)
}

# Apply the function to modify titles
t[, modified_title := sapply(title, keep_only_topics, topics)]

# merge of topics
t[, modified_title := gsub("US", "U.S.", modified_title)]


# proporition of rows where at least one topic is found
nrow(t[modified_title != ""]) / nrow(t)
# 34%

# explode modified_title to have one row per word from that string
exploded_dt <- t[, .(word = unlist(strsplit(modified_title, " "))), by = list(year,month)]

tg = exploded_dt[, .N, by=list(year, month, word)]
tg = tg[order(year,month,-N)]
tg[, .SD[1], by=list(year,month)]

# ====================
# keep only top topic
# ====================
tg1 = tg[, .SD[1], by=list(year,month)]

# ====================
# display all top topics
# ====================
tg1[, word]

#[1] "YouTube"  "Startup"  "Startup"  "Google"   "Google"   "Google"   "Facebook" "Facebook" "Google"   "YC"       "Google"   "Google"   "Google"   "Google"   "Google"  
#[16] "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[31] "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[46] "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[61] "Google"   "Google"   "Google"   "Google"   "Facebook" "Google"   "Google"   "Google"   "Apple"    "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[76] "Google"   "Google"   "NSA"      "NSA"      "NSA"      "NSA"      "Google"   "Bitcoin"  "Bitcoin"  "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[91] "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[106] "Google"   "Google"   "Google"   "Google"   "Apple"    "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Trump"    "Google"  
#[121] "Trump"    "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Bitcoin"  "Bitcoin"  "Google"   "Google"   "Facebook"
#[136] "Facebook" "Google"   "GitHub"   "Google"   "Google"   "Google"   "Google"   "Google"   "U.S."     "Google"   "Google"   "Google"   "Google"   "Google"   "Google"  
#[151] "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "Covid-19" "Covid-19" "Covid-19" "Apple"    "U.S."     "U.S."     "U.S."    
#[166] "Google"   "Apple"    "Google"   "Google"   "Google"   "Google"   "Google"   "Google"   "U.S."     "U.S."     "Apple"    "Apple"    "Facebook" "U.S."     "U.S."    
#[181] "Google"   "Ukraine"  "Ukraine"  "Twitter"  "U.S."     "U.S."     "U.S."     "U.S."     "U.S."     "Twitter"  "Twitter"  "Twitter"  "U.S."     "AI"       "AI"      
#[196] "AI"  
