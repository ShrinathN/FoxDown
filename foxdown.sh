#!/bin/bash

SUPPLIED_LINK="$1"
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
CURRENT_CHAPTER=""
CURRENT_CHAPTER_BASE_URL=""



wget -U="$USER_AGENT" -O main_page.html "$SUPPLIED_LINK" #this downloads the main link page
grep -o fanfox.net/manga/[^\"]*1.html main_page.html | tac > chapters_list.txt #this is to get all the individual chapters from the main page into a file called chapters_list.txt


#looping over all the chapters
while read CURRENT_CHAPTER
do
	echo Downloading "$CURRENT_CHAPTER"
	wget -U="$USER_AGENT" -O current_chapter.html "$CURRENT_CHAPTER" #downloads the current chapter
	grep -o ">"[0-9]*"<" current_chapter.html | uniq | grep -o -c "[0-9]*" >> page_list.txt # to obtain the number of pages in the chapter
	 CURRENT_CHAPTER_BASE_URL = $(printf "$CURRENT_CHAPTER" | grep -o "fanfox.net/.*[^1.html]") # saves the base URL in variable
	while read CURRENT_PAGE_NUMBER #loops over all the 
	do
		wget -U="$USER_AGENT" -O current_page.html "$CURRENT_CHAPTER_BASE_URL/$CURRENT_PAGE_NUMBER"
		wget -nc $(grep -o -m 1 a.fanfox.net/store/manga[^?]* current_page.html) # this is to get the image url from the page, and download it
	done < page_list.txt

done < chapters_list.txt
