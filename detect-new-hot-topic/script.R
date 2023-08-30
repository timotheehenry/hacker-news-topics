# continuation of script in previous folder

# ===========================================
# hacker news: new topic detection in top n
# ===========================================
# start from tg

tg_top = tg[rank <= 30]

seen_words = c()
tg_top$new_topic = ""
nb_rows = nrow(tg_top)

for(i in 1:nb_rows)
{
  if(!(tg_top[i, word] %in% seen_words))
  {
    this_new_topic = tg_top[i, word]
    tg_top[i, new_topic := this_new_topic]
    seen_words = c(seen_words, tg_top[i, word])
  }
  
}

tg_top[year >= 2015][new_topic != ""]

# long to wide
tg_top_extract = tg_top[new_topic != ""][, list(year,month,new_topic)]
#tg_top_extract = tg_top_extract[, list(list(new_topic)), by=list(year,month)]
tg_top_extract = tg_top_extract[, .SD[1], by=list(year,month)]

wide_table <- dcast(tg_top_extract, year ~ month, value.var = "new_topic")

# replace NAs
wide_table[is.na(wide_table)] <- ""

wide_table

