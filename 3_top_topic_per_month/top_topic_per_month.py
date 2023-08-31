import pandas as pd
df = pd.read_csv("hn-titles-200-points-topic-found-davinci-prompt-v2.csv")
df = df[df.topic != ""]
df = df.dropna(subset=['topic'])

df = df[['created_at','title','topic']]

# ========================
# get top topic per month
# ========================
# Convert 'created_at' to datetime
df['created_at'] = pd.to_datetime(df['created_at'])

# Extract year and month
df['year'] = df['created_at'].dt.year
df['month'] = df['created_at'].dt.month

# Group by year, month, and topic, then count occurrences
topic_counts = df.groupby(['year', 'month', 'topic']).size().reset_index(name='count')

# Find the top topic by row count for each month
top_topics = topic_counts.groupby(['year', 'month']) \
                         .apply(lambda x: x[x['count'] == x['count'].max()]) \
                         .reset_index(drop=True)

print(top_topics)


# ========================
# Find the top 3 topics by row count for each month
# ========================
top_topics_by_month = topic_counts.groupby(['year', 'month']) \
                                  .apply(lambda x: x.nlargest(3, 'count')) \
                                  .reset_index(drop=True)

# Group by year and month again to create a list of top topics per month
top_topics_list = top_topics_by_month.groupby(['year', 'month'])['topic'].apply(list).reset_index()

print(top_topics_list)

"""
    year  month                                   topic
0   2020     12       [Programming, Computing, Privacy]
1   2021      1       [Programming, Computing, Privacy]
2   2021      2  [Programming, Cryptocurrency, Privacy]
3   2021      3      [Programming, Security, Computing]
4   2021      4         [Privacy, Hacking, Programming]
5   2021      5       [Programming, Privacy, Computing]
6   2021      6          [Programming, Privacy, Gaming]
7   2021      7       [Programming, Privacy, Computing]
8   2021      8         [Privacy, Hacking, Programming]
9   2021      9   [Programming, Security, Surveillance]
10  2021     10       [Programming, Privacy, Computing]
11  2021     11       [Programming, Computing, Hacking]
12  2021     12         [Programming, Security, Gaming]
13  2022      1            [Programming, Gaming, Linux]
14  2022      2    [Programming, Computing, Networking]
15  2022      3         [Programming, Gaming, Security]
16  2022      4            [AI, Programming, Computing]
17  2022      5         [Programming, Gaming, Security]
18  2022      6          [Programming, Gaming, Privacy]
19  2022      7        [Programming, Networking, Fraud]
20  2022      8               [Programming, AI, Gaming]
21  2022      9            [Gaming, Computing, Privacy]
22  2022     10         [Programming, Gaming, Software]
23  2022     11        [Programming, Security, Layoffs]
24  2022     12      [Programming, Security, Computing]
25  2023      1        [Programming, Layoffs, Security]
26  2023      2              [AI, Programming, Layoffs]
27  2023      3               [AI, Programming, Gaming]
28  2023      4              [AI, Privacy, Programming]
29  2023      5           [AI, Programming, Networking]
30  2023      6                 [AI, Reddit, Computing]
31  2023      7       [Programming, Gaming, Networking]
32  2023      8              [Programming, AI, Hacking]
"""

