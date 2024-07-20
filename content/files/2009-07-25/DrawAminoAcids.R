source("DrawMolecule.R")
source("AminoAcids.R")

draw_amino_acids <- function(toFile = FALSE) {

	aa_matrix <- matrix(c(
		"G", "A", "S", "C", "U", "",
		"P", "V", "T", "M", "",  "",
		"",  "L", "D", "N", "K", "O",
		"",  "I", "E", "Q", "R", "",
		"",  "F", "Y", "W", "H", ""),
		5, 6, byrow = TRUE
	)

	w <- rep(16, 6)
	x <- 1 + c(0, sapply(2:length(w), function(n) sum(w[1:(n-1)] + 1)))
	h <- c(18, 18, 23, 20, 19)
	y <- 100 - c(0, sapply(2:length(h), function(n) sum(h[1:(n-1)] + 1)))

	bgcolors <- c(
		G = "peachpuff", P = "peachpuff",
		A = "turquoise", V = "turquoise", L = "turquoise", I = "turquoise", F = "turquoise",
		S = "lightgreen", T = "lightgreen", Y = "lightgreen",
		D = "pink", E = "pink",
		H = "skyblue", K = "skyblue", R = "skyblue",
		W = "lightsalmon",
		C = "gold", M = "gold",
		N = "thistle", Q = "thistle",
		U = "wheat", O = "wheat"
	)

	for (aa_class in c("", names(aa_classes), "")) {

		if (toFile) {
			png(paste("aa", ifelse(aa_class == "", "", "-"), aa_class, ".png", sep = ""), 900, 900)
		} else {
			cat("Press <Enter> to continue...\n")
			readLines(n = 1)
			cat(aa_class, "\n")
		}

		init_screen(100, 100, bg = "cornsilk")
		for (i in 1:nrow(aa_matrix)) {
			for (j in 1:ncol(aa_matrix)) {
				aa <- amino_acids[[ aa_matrix[i, j] ]]

				if ( ! is.null(aa)) {
					bgcol = bgcolors[aa$letter]
					bdcol = bgcol
					if (aa_class != "") {
						if ( ! aa$letter %in% aa_classes[[aa_class]]) {
							color = col2rgb(bgcol) + (col2rgb(par("bg")) - col2rgb(bgcol)) * 0.9
							bgcol = rgb(color[1], color[2], color[3], maxColorValue = 255)
							bdcol = bgcol
						} else {
							bdcol = "red"
						}
					}
					text = paste(aa$name, "\n(", aa$abbr, "/", aa$letter, ")")
					rect(-5, -5, 17, 17, col = par("bg"), border = par("bg"))
					text(0, 0, aa_class, pos = 4)
					rect(x[j], y[i], x[j] + w[j], y[i] - h[i], col = bgcol, border = bdcol)
					draw_molecule(aa, x[j], y[i], w[j], h[i], text, text_col = "blue", text_bgcol = bgcol)
				}
			}
		}
		if (toFile) dev.off()
	}
}

draw_amino_acids(FALSE)
