init_screen <- function(width = 1, height = 1, mar = rep(0, 4), bg = par("bg"), ...) {
	par(mar = mar)
	par(bg = bg)
	plot(c(0, width), c(0, height), type = "n", xlab = "", ylab = "", axes = FALSE, ...)
}

draw_molecule <- function(molecule, x = 0, y = 0, w = 0, h = 0, text = "", text_col = "blue", text_bgcol = par("bg")) {

	directions <- c('up', 'upright', 'right', 'downright', 'down', 'downleft', 'left', 'upleft')

	moving <- list(
		'up'        = list(x = 0,            y = 2),
		'upright'   = list(x = sqrt(3),      y = 1),
		'right'     = list(x = 2 * sqrt(3),  y = 0),
		'downright' = list(x = sqrt(3),      y = -1),
		'down'      = list(x = 0,            y = -2),
		'downleft'  = list(x = -sqrt(3),     y = -1),
		'left'      = list(x = -2 * sqrt(3), y = 0),
		'upleft'    = list(x = -sqrt(3),     y = 1)
	)

	calc_bond_pos <- function(pos, bond) {
		x1 <- pos[1]
		y1 <- pos[2]
		x2 <- x1 + moving[[bond$direction]]$x
		y2 <- y1 + moving[[bond$direction]]$y
		return(c(x2, y2))
	}

	draw_bond <- function(pos1, pos2, bond) {
		x1 <- pos1[1]
		y1 <- pos1[2]
		x2 <- pos2[1]
		y2 <- pos2[2]
		if (bond$type == "single") {
			segments(x1, y1, x2, y2)
		} else if (bond$type == "double") {
			dx = (y1 - y2) / 15
			dy = (x2 - x1) / 15
			segments(x1 + dx, y1 + dy, x2 + dx, y2 + dy)
			dx = -dx
			dy = -dy
			segments(x1 + dx, y1 + dy, x2 + dx, y2 + dy)
		} else if (bond$type == "triple") {
			segments(x1, y1, x2, y2)
			dx = (y1 - y2) / 8
			dy = (x2 - x1) / 8
			segments(x1 + dx, y1 + dy, x2 + dx, y2 + dy)
			dx = -dx
			dy = -dy
			segments(x1 + dx, y1 + dy, x2 + dx, y2 + dy)
		}
		return(c(x2, y2))
	}

	if (length(molecule$atoms) > 0) {
		pos <- matrix(0, ncol = 2, nrow = length(molecule$atoms))
		for (i in seq_along(molecule$atoms)) {
			bonds <- matrix(sapply(molecule$bonds, function(x) sort(c(x$start, x$end))), ncol = 2, byrow = TRUE)
			for (j in seq_along(molecule$bonds)) {
				if (i == bonds[j, 1]) {
					pos[bonds[j, 2],] <- calc_bond_pos(pos[bonds[j, 1],], molecule$bonds[[j]])
				}
			}
		}
		pos[,1] <- pos[,1] - min(pos[,1]) + x
		pos[,2] <- pos[,2] - max(pos[,2]) + y
		if (w > 0) {
			pos[,1] <- pos[,1] + (w - (max(pos[,1]) - min(pos[,1]))) / 2
		}
		if (h > 0) {
			pos[,2] <- pos[,2] - (h - (max(pos[,2]) - min(pos[,2]))) / 2
			if ( ! is.null(text) && text != "") {
				pos[,2] <- pos[,2] + 3
			}
		}

		for (i in seq_along(molecule$bonds)) {
			draw_bond(pos[molecule$bonds[[i]]$start,], pos[molecule$bonds[[i]]$end,], molecule$bonds[[i]])
		}
		fontSize = 0.6;
		for (i in seq_along(molecule$atoms)) {
			if (molecule$atoms[i] != "C") {
				rect(pos[i, 1] - fontSize, pos[i, 2] - fontSize, pos[i, 1] + fontSize, pos[i, 2] + fontSize, col = text_bgcol, border = text_bgcol)
				text(pos[i, 1], pos[i, 2], molecule$atoms[i])
			}
		}

		if ( ! is.null(text) && text != "") {
			text_x <- x
			text_y <- min(pos[,2]) - 1
			text_pos <- 1
			if (w > 0) {
				text_x <- x + w / 2
			}
			if (h > 0) {
				text_y <- y - h
				text_pos <- 3
			}
			text(text_x, text_y, text, col = text_col, pos = text_pos)
		}
	}
}
