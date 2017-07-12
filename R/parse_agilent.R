#' Parse the oddly formatted .csv files exported by Agilent's MassHunter software into an R data frame.
#'
#' @param filename A string with the path of the relevant .csv file.
#' @return A data frame with columns "file", "metadata", "time" and "intensity".
#' 
#' @export
parse_agilent_cgram_csv <- function(filename){
	require(stringr)
	require(data.table)
    raw.text <- readLines(filename)
    n.lines <- length(raw.text)
    
    # header lines start with '#' and come in pairs;
    # the first line has metadata and the second has actual headers
    header.lines <- which(str_detect(raw.text, '[#]'))
    data.lines <- !str_detect(raw.text, '[#]')
	
	# reformat for use of the much-faster data.table::fread() function
	raw.text.input <- paste0(raw.text[data.lines], collapse = '\n')
	raw.df <- fread(input = raw.text.input, 
                sep = ",", 
                header = F, 
                stringsAsFactors = F,
                colClasses = c('NULL', 'numeric', 'numeric')
                )
    
    
    # keep only odd elements of header_lines http://stackoverflow.com/a/13462110/4480692
    header.starts <- header.lines[c(TRUE, FALSE)]
    num.headers <- length(header.starts)
    data.starts <- header.starts + 2
    data.ends <- c(header.starts[2:num.headers] - 1, n.lines)
    
    # adjust for line numbering in filtered data
    data.lengths <- data.ends - data.starts + 1
    new.ends <- cumsum(data.lengths)
    new.starts <- c(1, new.ends[1:(num.headers-1)] + 1)
	
	# add metadata by block
	metadata <- raw.text[header.starts[seq_along(new.starts)]]
	
	# attempt to parse the metadata
	this.file <- str_extract(metadata, "[:graph:]+[.]d")
	signal <- str_extract(metadata, "[-]ESI|[/+]ESI|DAD|[-]Mixed|[/+]Mixed|Pressure|[+]APCI")
	mzs <- str_extract(metadata, "(EIC|APCI|MRM)[:12 ]*[(].*[)]")
	
	# fill in each block with parsed metadata
	n.blocks <- length(data.lengths)
	block.idxs <- rep(1:n.blocks, data.lengths)
	raw.df$metadata <- metadata[block.idxs]
	raw.df$file <- this.file[block.idxs]
	raw.df$signal <- signal[block.idxs]
	raw.df$mzs <- mzs[block.idxs]
	raw.df$metadata <- metadata[block.idxs]
	
    # rename data colums
    names(raw.df)[1:2] <- c('time', 'intensity')	
    return(raw.df)
}

#' Parse the oddly formatted .csv files exported by Agilent's MassHunter software into an R data frame.
#'
#' @param filename A string with the path of the relevant .csv file.
#' @return A data frame with columns "V2", "V3", "file" and "intensity"
#' 
#' @export
parse_agilent_spectrum_csv <- function(filename){
	require(stringr)
	require(data.table)
    raw.text <- readLines(filename)
    n.lines <- length(raw.text)
    
    # header lines start with '#' and come in pairs;
    # the first line has metadata and the second has actual headers
    header.lines <- which(str_detect(raw.text, '[#]'))
    data.lines <- !str_detect(raw.text, '[#]')
	
	# reformat for use of the much-faster data.table::fread() function
	raw.text.input <- paste0(raw.text[data.lines], collapse = '\n')
	raw.df <- fread(input = raw.text.input, 
                sep = ",", 
                header = F, 
                stringsAsFactors = F,
                colClasses = c('NULL', 'numeric', 'numeric')
                )
    
    
    # keep only odd elements of header_lines http://stackoverflow.com/a/13462110/4480692
    header.starts <- header.lines[c(TRUE, FALSE)]
    num.headers <- length(header.starts)
    data.starts <- header.starts + 2
    data.ends <- c(header.starts[2:num.headers] - 1, n.lines)
    
    # now must adjust for line numbering in filtered data
    data.lengths <- data.ends - data.starts + 1
    new.ends <- cumsum(data.lengths)
    new.starts <- c(1, new.ends[1:(num.headers-1)] + 1)
	
	# add metadata by block
	metadata <- raw.text[header.starts[seq_along(new.starts)]]
	
	this.file <- str_extract(metadata, "[:graph:]+[.]d")
	signal <- str_extract(metadata, "[-]ESI|[/+]ESI|DAD|[-]Mixed|[/+]Mixed|Pressure|[+]APCI")
	rts <- str_extract(metadata, "(EIC|APCI|UV)[:12 ]*[(].*[)]")
	
	n.blocks <- length(data.lengths)

	block.idxs <- rep(1:n.blocks, data.lengths)

	raw.df$metadata <- metadata[block.idxs]
	raw.df$file <- this.file[block.idxs]
	raw.df$signal <- signal[block.idxs]
	raw.df$rts <- rts[block.idxs]
	raw.df$metadata <- metadata[block.idxs]
	
    # rename data colums
    names(raw.df)[1:2] <- c('mz', 'intensity')	
    return(raw.df)
}
