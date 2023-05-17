from turtle import title
from django.shortcuts import render

from . import util

import random

from markdown2 import Markdown

markdowner = Markdown()

def index(request):
    return render(request, "encyclopedia/index.html", {
        "entries": util.list_entries()
    })

def entry(request,entry):
    content = util.get_entry(entry)
    try:
        return render(request, "encyclopedia/entry.html", {
        "entry" : markdowner.convert(content),
        })
    except TypeError:
        return render(request, "encyclopedia/pagenotexist.html")        


def search(request):
    if request.method == "POST":
        searched = request.POST['q']
        content = util.get_entry(searched)
        if content is not None:
            return render(request, "encyclopedia/entry.html", {
                "entry" : markdowner.convert(content),
                })
        else:
            suggestions = []
            all_entries = util.list_entries()
            for entry in all_entries:
                if searched.upper() in entry.upper():
                    suggestions.append(entry)
            return render(request, "encyclopedia/result.html", {
                "suggestions" : suggestions
            })

def newpage(request):
    if request.method == "POST":
        title = request.POST['entrytitle']
        content = request.POST['addentry']
        Title_exist = util.get_entry(title)
        if Title_exist is not None:
            return render(request, "encyclopedia/pageexist.html")
        util.save_entry(title, content)
        return render(request, "encyclopedia/entry.html", {
            "title" : title,
            "entry" : markdowner.convert(content),
        })
    else:
        return render(request, "encyclopedia/newpage.html")


def edit(request):
    e_title = request.POST['a']
    econtent = util.get_entry(e_title)
    return render(request, "encyclopedia/edit.html", {
    "title" : e_title,
    "entry" : econtent,
    })

def save(request):
    if request.method == "POST":
        s_title = request.POST['edited_title']
        s_content = request.POST['edited_content']
        util.save_entry(s_title, s_content)
        return render(request, "encyclopedia/entry.html", {
            "title" : s_title,
            "entry" : markdowner.convert(s_content)
        })

def randompage(request):
    call_entry = util.list_entries()
    random_title = random.choice(call_entry)
    entry_content = util.get_entry(random_title)
    return render(request, "encyclopedia/entry.html", {
        "title" : random_title,
        "entry" : markdowner.convert(entry_content),
        })