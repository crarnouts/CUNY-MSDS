library(knitr)
library(XML)
library(httr)
library(rjson)
library(RCurl)
library(jsonlite)


#Loading in the html data from github
html_url<-readHTMLTable(getURL("https://raw.githubusercontent.com/crarnouts/CUNY-MSDS/master/books.html"))
html_url<-lapply(html_url[[1]], function(x) {unlist(x)})
df.html<-as.data.frame(html_url)
kable(df.html)
is.data.frame(df.html)

#Loading in the JSON data from github
json_url<-fromJSON(getURL("https://raw.githubusercontent.com/crarnouts/CUNY-MSDS/master/books.JSON"))
json_url<-lapply(json_url[[1]], function(x) {unlist(x)})
df.json<-as.data.frame(do.call("rbind", json_url))
kable(df.json)
is.data.frame(df.json)

#Loading in the XML data from github
xml_url<-xmlInternalTreeParse(getURL("https://raw.githubusercontent.com/crarnouts/CUNY-MSDS/master/books3.xml"))
xml_apply<-xmlSApply(xmlRoot(xml_url), function(x) xmlSApply(x, xmlValue))
df.xml<-data.frame(t(xml_apply), row.names = NULL)
kable(df.xml)
is.data.frame(df.xml)