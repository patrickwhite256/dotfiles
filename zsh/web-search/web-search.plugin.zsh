# web_search from terminal
# identical to the oh-my-zsh web_search, but removes some of the annoying aliases for search engines I don't use.
# TODO: make it possible to do complex searches (e.g. including quotes)

function web_search() {
  emulate -L zsh

  # define search engine URLS
  typeset -A urls
  urls=(
    $ZSH_WEB_SEARCH_ENGINES
    google      "https://www.google.com/search?q="
    bing        "https://www.bing.com/search?q="
    yahoo       "https://search.yahoo.com/search?p="
    duckduckgo  "https://www.duckduckgo.com/?q="
    startpage   "https://www.startpage.com/do/search?q="
    yandex      "https://yandex.ru/yandsearch?text="
    github      "https://github.com/search?q="
    baidu       "https://www.baidu.com/s?wd="
    ecosia      "https://www.ecosia.org/search?q="
    goodreads   "https://www.goodreads.com/search?q="
    qwant       "https://www.qwant.com/?q="
    givero      "https://www.givero.com/search?q="
    stackoverflow  "https://stackoverflow.com/search?q="
    wolframalpha   "https://www.wolframalpha.com/input/?i="
    archive     "https://web.archive.org/web/*/"
    scholar        "https://scholar.google.com/scholar?q="
    scryfall    "https://scryfall.com/search?q="
  )

  # check whether the search engine is supported
  if [[ -z "$urls[$1]" ]]; then
    echo "Search engine '$1' not supported."
    return 1
  fi

  # search or go to main page depending on number of arguments passed
  if [[ $# -gt 1 ]]; then
    # build search url:
    # join arguments passed with '+', then append to search engine URL
    url="${urls[$1]}${(j:+:)@[2,-1]}"
  else
    # build main page url:
    # split by '/', then rejoin protocol (1) and domain (2) parts with '//'
    url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
  fi

  open_command "$url"
}


alias google='web_search google'
alias github='web_search github'
alias stackoverflow='web_search stackoverflow'
alias scryfall='web_search scryfall'

# other search engine aliases
if [[ ${#ZSH_WEB_SEARCH_ENGINES} -gt 0 ]]; then
  typeset -A engines
  engines=($ZSH_WEB_SEARCH_ENGINES)
  for key in ${(k)engines}; do
    alias "$key"="web_search $key"
  done
  unset engines key
fi
