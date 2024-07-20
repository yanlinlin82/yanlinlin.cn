amino_acids <- list(
	A = list(
		name = "alanine",
		abbr = "Ala",
		letter = "A",
		MW = 89.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single')
		)
	),

	C = list(
		name = "cysteine",
		abbr = "Cys",
		letter = "C",
		MW = 121.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'S'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single')
		)
	),

	D = list(
		name = "aspartic acid",
		abbr = "Asp",
		letter = "D",
		MW = 133.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'O', 'O'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single'),
			list(start = 7, end = 8, direction = 'up',        type = 'double'),
			list(start = 7, end = 9, direction = 'downright',  type = 'single')
		)
	),

	E = list(
		name = "glutamic acid",
		abbr = "Glu",
		letter = "E",
		MW = 147.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'O', 'O'),
		bonds = list(
			list(start = 1, end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3,  direction = 'downright', type = 'single'),
			list(start = 3, end = 4,  direction = 'down',      type = 'double'),
			list(start = 3, end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1, end = 6,  direction = 'up',        type = 'single'),
			list(start = 6, end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7, end = 8,  direction = 'up',        type = 'single'),
			list(start = 8, end = 9,  direction = 'upleft',    type = 'double'),
			list(start = 8, end = 10, direction = 'upright',   type = 'single')
		)
	),

	F = list(
		name = "phenylalanine",
		abbr = "Phe",
		letter = "F",
		MW = 165.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', rep('C', 6)),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7,  end = 8,  direction = 'downright', type = 'double'),
			list(start = 8,  end = 9,  direction = 'upright',   type = 'single'),
			list(start = 9,  end = 10, direction = 'up',        type = 'double'),
			list(start = 10, end = 11, direction = 'upleft',    type = 'single'),
			list(start = 11, end = 12, direction = 'downleft',  type = 'double'),
			list(start = 12, end = 7,  direction = 'down',      type = 'single')
		)
	),

	G = list(
		name = "glycine",
		abbr = "Gly",
		letter = "G",
		MW = 75.1,
		atoms = c('C', 'N', 'C', 'O', 'O'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single')
		)
	),

	H = list(
		name = "histidine",
		abbr = "His",
		letter = "H",
		MW = 155.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'N', 'C', 'N', 'C'),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7,  end = 8,  direction = 'right',     type = 'single'),
			list(start = 8,  end = 9,  direction = 'up',        type = 'single'),
			list(start = 9,  end = 10, direction = 'upleft',    type = 'double'),
			list(start = 10, end = 11, direction = 'downleft',  type = 'single'),
			list(start = 11, end = 7,  direction = 'down',      type = 'double')
		)
	),

	I = list(
		name = "isoleucine",
		abbr = "Ile",
		letter = "I",
		MW = 131.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'C'),
		bonds = list(
			list(start = 1, end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3,  direction = 'downright', type = 'single'),
			list(start = 3, end = 4,  direction = 'down',      type = 'double'),
			list(start = 3, end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1, end = 6,  direction = 'up',        type = 'single'),
			list(start = 6, end = 7,  direction = 'upleft',    type = 'single'),
			list(start = 6, end = 8,  direction = 'upright',   type = 'single'),
			list(start = 8, end = 9,  direction = 'up',        type = 'single')
		)
	),

	K = list(
		name = "lysine",
		abbr = "Lys",
		letter = "K",
		MW = 146.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'C', 'N'),
		bonds = list(
			list(start = 1, end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3,  direction = 'downright', type = 'single'),
			list(start = 3, end = 4,  direction = 'down',      type = 'double'),
			list(start = 3, end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1, end = 6,  direction = 'up',        type = 'single'),
			list(start = 6, end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7, end = 8,  direction = 'up',        type = 'single'),
			list(start = 8, end = 9,  direction = 'upleft',    type = 'single'),
			list(start = 9, end = 10, direction = 'up',        type = 'single')
		)
	),

	L = list(
		name = "leucine",
		abbr = "Leu",
		letter = "L",
		MW = 131.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'C'),
		bonds = list(
			list(start = 1, end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3,  direction = 'downright', type = 'single'),
			list(start = 3, end = 4,  direction = 'down',      type = 'double'),
			list(start = 3, end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1, end = 6,  direction = 'up',        type = 'single'),
			list(start = 6, end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7, end = 8,  direction = 'up',        type = 'single'),
			list(start = 7, end = 9,  direction = 'downright', type = 'single')
		)
	),

	M = list(
		name = "methionine",
		abbr = "Met",
		letter = "M",
		MW = 149.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'S', 'C'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single'),
			list(start = 7, end = 8, direction = 'up',        type = 'single'),
			list(start = 8, end = 9, direction = 'upleft',    type = 'single')
		)
	),

	N = list(
		name = "asparagine",
		abbr = "Asn",
		letter = "N",
		MW = 132.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'O', 'N'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single'),
			list(start = 7, end = 8, direction = 'up',        type = 'double'),
			list(start = 7, end = 9, direction = 'downright',  type = 'single')
		)
	),

	P = list(
		name = "proline",
		abbr = "Pro",
		letter = "P",
		MW = 115.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C'),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'left',      type = 'single'),
			list(start = 7,  end = 8,  direction = 'down',      type = 'single'),
			list(start = 8,  end = 2,  direction = 'downright', type = 'single')
		)
	),

	Q = list(
		name = "glutamine",
		abbr = "Gln",
		letter = "Q",
		MW = 146.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'O', 'N'),
		bonds = list(
			list(start = 1, end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3,  direction = 'downright', type = 'single'),
			list(start = 3, end = 4,  direction = 'down',      type = 'double'),
			list(start = 3, end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1, end = 6,  direction = 'up',        type = 'single'),
			list(start = 6, end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7, end = 8,  direction = 'up',        type = 'single'),
			list(start = 8, end = 9,  direction = 'upleft',    type = 'double'),
			list(start = 8, end = 10, direction = 'upright',   type = 'single')
		)
	),

	R = list(
		name = "arginine",
		abbr = "Arg",
		letter = "R",
		MW = 174.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'N', 'C', 'N', 'N'),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7,  end = 8,  direction = 'up',        type = 'single'),
			list(start = 8,  end = 9,  direction = 'upleft',    type = 'single'),
			list(start = 9,  end = 10, direction = 'up',        type = 'single'),
			list(start = 10, end = 11, direction = 'upleft',    type = 'double'),
			list(start = 10, end = 12, direction = 'upright',   type = 'single')
		)
	),

	S = list(
		name = "serine",
		abbr = "Ser",
		letter = "S",
		MW = 105.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'O'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single')
		)
	),

	T = list(
		name = "threonine",
		abbr = "Thr",
		letter = "T",
		MW = 119.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'O', 'C'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single'),
			list(start = 6, end = 8, direction = 'upleft',    type = 'single')
		)
	),

	V = list(
		name = "valine",
		abbr = "Val",
		letter = "V",
		MW = 117.1,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upleft',    type = 'single'),
			list(start = 6, end = 8, direction = 'upright',   type = 'single')
		)
	),

	W = list(
		name = "tryptophan",
		abbr = "Trp",
		letter = "W",
		MW = 204.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'N', 'C', 'C', 'C', 'C', 'C', 'C'),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7,  end = 8,  direction = 'up',        type = 'double'),
			list(start = 8,  end = 9,  direction = 'upright',   type = 'single'),
			list(start = 9,  end = 10, direction = 'downright', type = 'single'),
			list(start = 10, end = 11, direction = 'down',      type = 'double'),
			list(start = 7,  end = 11, direction = 'right',     type = 'single'),
			list(start = 11, end = 12, direction = 'downright', type = 'single'),
			list(start = 12, end = 13, direction = 'upright',   type = 'double'),
			list(start = 13, end = 14, direction = 'up',        type = 'single'),
			list(start = 14, end = 15, direction = 'upleft',    type = 'double'),
			list(start = 15, end = 10, direction = 'downleft',  type = 'single')
		)
	),

	Y = list(
		name = "tyrosine",
		abbr = "Tyr",
		letter = "Y",
		MW = 181.2,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', rep('C', 6), 'O'),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7,  end = 8,  direction = 'downright', type = 'double'),
			list(start = 8,  end = 9,  direction = 'upright',   type = 'single'),
			list(start = 9,  end = 10, direction = 'up',        type = 'double'),
			list(start = 10, end = 11, direction = 'upleft',    type = 'single'),
			list(start = 11, end = 12, direction = 'downleft',  type = 'double'),
			list(start = 12, end = 7,  direction = 'down',      type = 'single'),
			list(start = 10, end = 13, direction = 'upright',   type = 'single')
		)
	),

	U = list(
		name = "selenocysteine",
		abbr = "Sec",
		letter = "U",
		MW = 168.053,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'Se'),
		bonds = list(
			list(start = 1, end = 2, direction = 'downleft',  type = 'single'),
			list(start = 1, end = 3, direction = 'downright', type = 'single'),
			list(start = 3, end = 4, direction = 'down',      type = 'double'),
			list(start = 3, end = 5, direction = 'upright',   type = 'single'),
			list(start = 1, end = 6, direction = 'up',        type = 'single'),
			list(start = 6, end = 7, direction = 'upright',   type = 'single')
		)
	),

	O = list(
		name = "pyrrolysine",
		abbr = "Pyl",
		letter = "O",
		MW = 255.31,
		atoms = c('C', 'N', 'C', 'O', 'O', 'C', 'C', 'C', 'C', 'N', 'C', 'O', 'C', 'N', rep('C', 4)),
		bonds = list(
			list(start = 1,  end = 2,  direction = 'downleft',  type = 'single'),
			list(start = 1,  end = 3,  direction = 'downright', type = 'single'),
			list(start = 3,  end = 4,  direction = 'down',      type = 'double'),
			list(start = 3,  end = 5,  direction = 'upright',   type = 'single'),
			list(start = 1,  end = 6,  direction = 'up',        type = 'single'),
			list(start = 6,  end = 7,  direction = 'upright',   type = 'single'),
			list(start = 7,  end = 8,  direction = 'up',        type = 'single'),
			list(start = 8,  end = 9,  direction = 'upleft',    type = 'single'),
			list(start = 9,  end = 10, direction = 'up',        type = 'single'),
			list(start = 10, end = 11, direction = 'upright',   type = 'single'),
			list(start = 11, end = 12, direction = 'up',        type = 'single'),
			list(start = 11, end = 13, direction = 'downright', type = 'single'),
			list(start = 13, end = 14, direction = 'down',      type = 'single'),
			list(start = 14, end = 15, direction = 'right',     type = 'double'),
			list(start = 15, end = 16, direction = 'up',        type = 'single'),
			list(start = 16, end = 17, direction = 'upleft',    type = 'single'),
			list(start = 13, end = 17, direction = 'upright',   type = 'single'),
			list(start = 17, end = 18, direction = 'up',        type = 'single')
		)
	)
)

aa_classes <- list(
	small = levels(as.factor(sapply(amino_acids, function(aa) ifelse(aa$MW <= 115, aa$letter, NA)))),
	medium = levels(as.factor(sapply(amino_acids, function(aa) ifelse(aa$MW > 115 && aa$MW <= 140, aa$letter, NA)))),
	large = levels(as.factor(sapply(amino_acids, function(aa) ifelse(aa$MW > 140, aa$letter, NA)))),
	aliphatic = c('A', 'G', 'I', 'L', 'V'),
	aromatic = c('F', 'W', 'Y'),
	acyclic = c('A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'I', 'L', 'K', 'M', 'S', 'T', 'V', 'U'),
	cyclic = c('H', 'F', 'P', 'W', 'Y', 'O'),
	acidic = c('D', 'E'),
	basic = c('R', 'H', 'K'),
	neutral = c('A', 'N', 'C', 'Q', 'G', 'I', 'L', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V'),
	charged = c('R', 'D', 'E', 'H', 'K'),
	positive = c('R', 'H', 'K'),
	negative = c('D', 'E'),
	hydrophobic = c('A', 'G', 'I', 'L', 'M', 'F', 'P', 'W', 'Y', 'V'),
	polar = c('R', 'N', 'D', 'C', 'E', 'Q', 'H', 'K', 'S', 'T'),
	buried = c('A', 'C', 'I', 'L', 'M', 'F', 'W', 'V'),
	surface = c('R', 'N', 'D', 'E', 'Q', 'G', 'H', 'K', 'P', 'S', 'T', 'Y'),
	essential = c('F', 'K', 'I', 'L', 'M', 'T', 'W', 'V'),
	essential2 = c('F', 'K', 'I', 'L', 'M', 'T', 'W', 'V', 'R', 'H'),
	newly = c('O', 'U')
)
