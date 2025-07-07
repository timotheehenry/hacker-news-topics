# create datasets of all HN stories posted that got more than 100 points

import requests
import pandas as pd
import datetime
from urllib3.exceptions import InsecureRequestWarning
from urllib3 import disable_warnings

disable_warnings(InsecureRequestWarning)

# ========
current_unix_timestamp = int(datetime.datetime.now().timestamp())
print("Current Unix Timestamp:", current_unix_timestamp)


df = pd.DataFrame({
    'created_at': ['2023-08-30T16:13:23.000Z'],
    'title': [''],
    'points': [0]
})

min_nb_points = 50
HITS_PER_PAGE = 1000

one_hour = 3600
one_day = 24 * one_hour # 1 day in seconds
one_week = 7 * one_day

INTERVAL = one_week

for i in range(200):
  print("i = ", i)
  time_1 = current_unix_timestamp - i * INTERVAL
  time_2 = time_1 + INTERVAL
  url = "https://hn.algolia.com/api/v1/search_by_date?hitsPerPage=" + str(HITS_PER_PAGE) + "&tags=(story)&numericFilters=points%3E" + str(min_nb_points) + ",created_at_i%3E=" + str(time_1) + ",created_at_i%3C=" + str(time_2)
  r = requests.get(url, verify=False)
  data = r.json()
  if data['nbHits']>0:
    df_temp = pd.json_normalize(data['hits'])
    df_temp = df_temp[['created_at','title','points']]
    print(df_temp)
    df = pd.concat([df, df_temp], ignore_index=True)

# get unique rows
df = df.drop_duplicates(subset=('title'))
df = df[df.title != ""]

# save dataset
df.to_csv("./hn-50-points-stories-2006-10-09-to-2023-08-31.csv")

