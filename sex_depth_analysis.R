
# Sex-chromosome dosage from whole-genome DNA read depth
# Species: Zalophus californianus
# Input: Samtools coverage TSV + chromosome labels

# 1. Read chromosome coverage data
cov <- read.delim(
  "data/chromosome_coverage.tsv",
  comment.char = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)

names(cov)[1] <- "rname"

if (!"meandepth" %in% names(cov)) {
  stop("Missing meandepth column")
}

# 2. Read chromosome groups
# First try the standard CSV format
key <- read.csv(
  "data/chromosome_groups.csv",
  stringsAsFactors = FALSE
)

# Handle CSV files whose entire rows were enclosed in quotes
if (!all(c("rname", "group") %in% names(key))) {
  raw_lines <- readLines(
    "data/chromosome_groups.csv",
    warn = FALSE
  )
  
  # Remove wrapping quotation marks from each line
  raw_lines <- trimws(raw_lines)
  raw_lines <- sub('^"', '', raw_lines)
  raw_lines <- sub('"$', '', raw_lines)
  
  key <- read.csv(
    text = paste(raw_lines, collapse = "\n"),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}

if (!all(c("rname", "group") %in% names(key))) {
  stop("Bad key columns: CSV must contain rname and group")
}

key$rname <- trimws(key$rname)
key$group <- toupper(trimws(key$group))

# 3. Validate chromosome labels
if (anyDuplicated(key$rname)) {
  stop("Repeated rname in key file")
}

if (!all(key$group %in% c("A", "X", "Y", "Z", "W"))) {
  stop("Use only A, X, Y, Z or W in the group column")
}

# 4. Combine labels and coverage data
x <- merge(
  key,
  cov[, c("rname", "meandepth")],
  by = "rname",
  all.x = TRUE,
  sort = FALSE
)

x$meandepth <- suppressWarnings(as.numeric(x$meandepth))

if (anyNA(x$meandepth)) {
  stop("Missing depths: check rname matches")
}

if (any(x$meandepth < 0)) {
  stop("Negative depth is not valid")
}

if (sum(x$group == "A") < 5) {
  stop("Label at least 5 autosomes")
}

if ("X" %in% x$group && "Z" %in% x$group) {
  stop("Choose either an XY or a ZW species, not both")
}

# 5. Identify sex-chromosome system
if (sum(x$group == "X") == 1 && !any(x$group == "Z")) {
  
  target <- "X"
  one_copy <- "XY-like"
  two_copies <- "XX-like"
  
} else if (sum(x$group == "Z") == 1 && !any(x$group == "X")) {
  
  target <- "Z"
  one_copy <- "ZW-like"
  two_copies <- "ZZ-like"
  
} else {
  stop("Label exactly one X or exactly one Z chromosome")
}

# 6. Calculate relative chromosome depth
A <- median(x$meandepth[x$group == "A"])

if (!is.finite(A) || A <= 0) {
  stop("No usable autosomal coverage")
}

x$relative_depth <- x$meandepth / A

ratio <- x$relative_depth[x$group == target]

# 7. Infer sex-chromosome dosage
call <- if (ratio >= 0.80) {
  two_copies
} else if (ratio <= 0.65) {
  one_copy
} else {
  "Ambiguous"
}

if (A < 1) {
  call <- "Inconclusive: very low autosomal depth"
}

# 8. Optional Y or W evidence
partner <- if (target == "X") "Y" else "W"

partner_ratio <- if (partner %in% x$group) {
  x$relative_depth[x$group == partner][1]
} else {
  NA_real_
}

# 9. Create results folder and export table
dir.create("results", showWarnings = FALSE)

write.csv(
  x,
  "results/chromosome_relative_depth.csv",
  row.names = FALSE
)

# 10. Create chromosome depth graph
png(
  "results/chromosome_depth.png",
  width = 1000,
  height = 580
)

par(mar = c(8, 4, 3, 1))

barplot(
  x$relative_depth,
  names.arg = x$rname,
  las = 2,
  ylab = "Depth relative to median autosome",
  main = "Autosomal and sex-chromosome depth",
  cex.names = 0.75
)

abline(h = c(0.5, 1.0), lty = 2)

dev.off()

# 11. Create interpretation summary
summary <- c(
  paste("Median autosome depth:", round(A, 3)),
  paste(target, "/ A ratio:", round(ratio, 3)),
  paste(partner, "/ A ratio:", round(partner_ratio, 3)),
  paste("Dosage interpretation:", call),
  "Compare with BioSample sex and discuss limitations."
)

writeLines(
  summary,
  "results/sex_inference.txt"
)

cat(paste(summary, collapse = "\n"), "\n")
