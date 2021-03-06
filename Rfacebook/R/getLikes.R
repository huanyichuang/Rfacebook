#' @rdname getLikes
#' @export
#'
#' @title 
#' Extract list of likes of the authenticated Facebook user
#'
#' @description
#' \code{getLikes} retrieves information about the authenticated use
#' only (not any friend). To retrieve the number of likes for a page, 
#' use \code{getUsers} with the page IDs.
#'
#' @details
#' 
#' This function requires the use of an OAuth token with the following
#' permission: user_likes
#'
#' @author
#' Pablo Barbera \email{pbarbera@@usc.edu}
#' @seealso \code{\link{getFriends}}, \code{\link{fbOAuth}}
#'
#' @param token Either a temporary access token created at
#' \url{https://developers.facebook.com/tools/explorer} or the OAuth token 
#' created with \code{fbOAuth}.
#'
#' @param user The name of the user. By default, "me".
#'
#' @param n Maximum number of likes to return for each user.
#'
#' @examples \dontrun{
#'  token <- 'XXXXX'
#'  my_likes <- getLikes(user="me", token=token)
#' }
#'

getLikes <- function(user="me", n=500, token){
	query <- paste0('https://graph.facebook.com/', user, 
		'?fields=likes.limit(', n, ').fields(id,name,website)')
	content <- callAPI(query, token)
    if ('data' %in% names(content$likes) == FALSE){
        stop("User not found, or token is not authorized.")
    }
    df <- userLikesToDF(content$likes$data)
    next_url <- content$likes$paging$`next`
    while (!is.null(next_url)){
    	content <- callAPI(next_url, token)
    	df <- rbind(df, userLikesToDF(content$data))
    	next_url <- content$paging$`next`
    }
	return(df)
}




