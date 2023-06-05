#' Collection of stopwords in multiple languages
#'
#' This function returns stop words contained in the \href{https://github.com/stopwords-iso/stopwords-iso}{StopwordsISO} repository.
#' 
#' @param lang Language for which to retrieve the stop word among those supported by \href{https://github.com/stopwords-iso/stopwords-iso}{StopwordISO}. This parameters supports: \itemize{
#'  \item three-letter ISO 639-2/3 codes (e.g., \code{'eng'});
#'  \item two-letter ISO639-1 codes (\code{'en'});
#'  \item names based ISO 639-2 codes (\code{'English'} or \code{'english'}) and their unambiguous substrings (\code{'engl'}, \code{'engli'}, etc.).
#' }
#' 
#' @return A character vector containing the stop words from the selected language as listed in the \href{https://github.com/stopwords-iso/stopwords-iso}{StopwordISO} repository.
#' 
#' @export
#' 
#' @examples
#' # They all return the correct list of stop words!
#' 
#' stopwords('German')
#' stopwords('germ')
#' stopwords('de')
#' stopwords('deu')

stopwords <- function(lang = 'en') {
  
  lang <- match.lang(lang = lang)
  
  if (lang %in% names(stopwordsISO)){
    stopwordsISO[[lang]]
  } else {
    stop(paste0(lang, ' is not supported by `StopwordsISO`!'))
  }
  
}

#' Returns all the ISO 639-1 code available in the Stopwords ISO library
#'
#' See the relevant \href{https://en.wikipedia.org/wiki/ISO_639-1}{Wikipedia article} for details of the language code.
#' 
#' @returns A data frame with a row for each supported languages and columns for the several ISO code (639-2, 639-3, 639-1) and the name.
#' 
#' @export

languages <- function() {
  
  # Extract language codes
  code <- names(stopwordsISO)
  
  # Prepare the table
  code <- ISOcodes[match(code, ISOcodes$`ISO639-1`),]
  rownames(code) <- NULL
  
  code
}




#' Returns all the ISO 639-1 code available in the Stopwords ISO library
#'
#' See \url{https://en.wikipedia.org/wiki/ISO_639-1} for details of the language code.
#' 
#' @param lang Either an ISO 639-2/3 or a language name from which to derive a ISO 639-2 code. For language names performs string matching.
#' 
#' @returns A character vector containing the two-letter ISO 639-1 code associated to the requested language.
#'
#' @export

match.lang <- function(lang){
  df <- languages()
  df$name <- tolower(df$name)
  lang <- tolower(lang)
  
  pos <- ifelse(test = nchar(lang)==2,
                # Possible 2-letter code
                yes = which(df$`ISO639-1`==lang),
                no = ifelse(test = nchar(lang)>3,
                       # Possible language name
                       yes = which(df$name==match.arg(lang, df$name)),
                       # Possible 3-letter code
                       no = ifelse(test = any(lang%in%df$`ISO639-2`),
                                    # Is it a IS O639-2 code?
                                    yes = which(df$`ISO639-2`==lang),
                                    # Otherwise, try as a ISO 639-3 code
                                    no = which(df$`ISO639-3`==lang))))
  
  if(is.na(pos)){
    # No match
    stop('Not a valid language (code): ', lang)
  } else {
    # Return match
    df$`ISO639-1`[pos]
  }
}


