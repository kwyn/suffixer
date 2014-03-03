angular.module "suffixer", ['ui.bootstrap']
 
  .controller 'frameController', ($scope, $http) =>
    $scope.idea = ''
    $scope.results
    $scope.filterState = "noFilter"
    ###############################################################
    # format data
    ###############################################################

    domain = [".aero",".biz",".cat",".com",".coop",".edu",".gov",".info",".int",".jobs",".mil",".mobi",".museum",
    ".name",".net",".org",".travel",".ac",".ad",".ae",".af",".ag",".ai",".al",".am",".an",".ao",".aq",".ar",".as",".at",".au",".aw",
    ".az",".ba",".bb",".bd",".be",".bf",".bg",".bh",".bi",".bj",".bm",".bn",".bo",".br",".bs",".bt",".bv",".bw",".by",".bz",".ca",
    ".cc",".cd",".cf",".cg",".ch",".ci",".ck",".cl",".cm",".cn",".co",".cr",".cs",".cu",".cv",".cx",".cy",".cz",".de",".dj",".dk",".dm",
    ".do",".dz",".ec",".ee",".eg",".eh",".er",".es",".et",".eu",".fi",".fj",".fk",".fm",".fo",".fr",".ga",".gb",".gd",".ge",".gf",".gg",".gh",
    ".gi",".gl",".gm",".gn",".gp",".gq",".gr",".gs",".gt",".gu",".gw",".gy",".hk",".hm",".hn",".hr",".ht",".hu",".id",".ie",".il",".im",
    ".in",".io",".iq",".ir",".is",".it",".je",".jm",".jo",".jp",".ke",".kg",".kh",".ki",".km",".kn",".kp",".kr",".kw",".ky",".kz",".la",".lb",
    ".lc",".li",".lk",".lr",".ls",".lt",".lu",".lv",".ly",".ma",".mc",".md",".mg",".mh",".mk",".ml",".mm",".mn",".mo",".mp",".mq",
    ".mr",".ms",".mt",".mu",".mv",".mw",".mx",".my",".mz",".na",".nc",".ne",".nf",".ng",".ni",".nl",".no",".np",".nr",".nu",
    ".nz",".om",".pa",".pe",".pf",".pg",".ph",".pk",".pl",".pm",".pn",".pr",".ps",".pt",".pw",".py",".qa",".re",".ro",".ru",".rw",
    ".sa",".sb",".sc",".sd",".se",".sg",".sh",".si",".sj",".sk",".sl",".sm",".sn",".so",".sr",".st",".su",".sv",".sy",".sz",".tc",".td",".tf",
    ".tg",".th",".tj",".tk",".tm",".tn",".to",".tp",".tr",".tt",".tv",".tw",".tz",".ua",".ug",".uk",".um",".us",".uy",".uz", ".va",".vc",
    ".ve",".vg",".vi",".vn",".vu",".wf",".ws",".ye",".yt",".yu",".za",".zm",".zr",".zw"]

    domainObject = {}

    domainObject[value.substring(1)] = value for value in domain

    vowelArray = ['a','e','i','o','u','y']

    ################################################################
    # Helper functions
    ################################################################
    # letter remover
    removeLetters = (word, letters) ->
      #letters = _.intersection word, letters 
      results = [word.join('')]

      remove = (wordCopy, index) ->
        if index < letters.length
          char = letters[index]
          charidx = wordCopy.indexOf char
          if charidx > -1
            copy = []
            copy = wordCopy[0...charidx].concat wordCopy[charidx+1 ..]
            results.push copy.join '' 
            if (copy.indexOf char) > -1 
              remove copy, index
            else
              remove copy, ++index
          remove wordCopy, ++index
        else
          return null
      copy = word[..]
      remove copy, 0
      results

    ###############################################################
    # TODO: Letter Substitution
    swapArray = [['f', ['ph']], ['j', ['g']], ['j', ['ge']], ['c', ['k']], ['q', ['k']], ['z',['s']], ['s', ['z']] ]  
    swapLetters = (word, swap)->
      results = [word.join('')]
      swapper = (wordCopy, index) ->
        if index < swap.length
          char = swap[index][0]
          charidx = wordCopy.indexOf char
          if charidx > -1
            copy = []
            copy = wordCopy[0...charidx].concat [swap[index][1][0]] .concat wordCopy[charidx+1 ..]
            if (results.indexOf copy) == -1
              results.push copy.join('')
            if (copy.indexOf char ) > -1
              swapper copy, index
            else
              swapper copy, ++index
          swapper wordCopy, ++index
        else
          return null
      copy = word[..]
      swapper copy, 0
      console.log results
      results

    ###############################################################
    # Find possible domains
    findDomains = (words) -> 
      domains = []
      findit = (word) ->
        wordArray = word.split ''
        suffixes = wordArray[-4..]
        results = []
        while suffixes.length > 1
          suffix = suffixes.join('')
          if domainObject[suffix] && (wordArray[0..-(suffixes.length+1)].length > 1)
            results.push wordArray[0..-(suffixes.length+1)].join('') + domainObject[suffixes.join('')]
            suffixes.shift()
          else
            suffixes.shift()
        results
      for word in words 
        domains.push("#{word}.com")
        domains.push("#{word}.net")
        domains.push("#{word}.org")

      for word in words
        domains.push item for item in findit word
      domains
    ###################################################################
    # Calls all the stuff above.
    ###################################################################
    $scope.removeVowels = false;
    $scope.search = (idea)->
      console.log $scope.filterState
      switch $scope.filterState
        when "filterVowels"
          options = removeLetters (idea.split '') , vowelArray
          $scope.results = findDomains options
        when "swap"
          options = swapLetters (idea.split '') , swapArray
          $scope.results = findDomains options
        else
          $scope.results = findDomains [idea]

      if $scope.results.length == 0
        $scope.fail = true
      else 
        $scope.fail = false
      
