import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

df = pd.read_csv("gapminder.csv")
by_country = df.groupby(by = ['country','continent'])

def country_model(data):
    x = data.year.values.reshape(-1, 1)
    y = data.lifeExp.values.reshape(-1,1)
    model = LinearRegression().fit(x, y)
    r2 = model.score(x, y)
    return r2

(by_country
        .apply(country_model)
        .reset_index()
        .rename(columns = {0: "r2"})
        .sort_values(by = ['r2']))

