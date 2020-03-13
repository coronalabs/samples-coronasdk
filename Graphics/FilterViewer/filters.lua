
local M = {

	["filter.bloom"] = {
		levels = { white = 0.8, black = 0.4, gamma = 1 },
		add = { alpha = 0.8 },
		blur = {
			horizontal = { blurSize = 20, sigma = 140 }
		},
		blur = {
			vertical = { blurSize = 20, sigma = 240 }
		}
	},

	["filter.blur"] = {},

	["filter.blurGaussian"] = {
		horizontal = { blurSize = 20, sigma = 140 },
		vertical = { blurSize = 20, sigma = 240 }
	},

	["filter.blurHorizontal"] = {
		blurSize = 100,
		sigma = 140
	},

	["filter.blurVertical"] = {
		blurSize = 100,
		sigma = 140
	},

	["filter.brightness"] = {
		intensity = 0.4
	},

	["filter.bulge"] = {
		intensity = 1.5
	},

	["filter.chromaKey"] = {
		sensitivity = 0.1,
		smoothing = 0.3,
		color = { 0.2, 0.2, 0.2, 1 }
	},

	["filter.colorChannelOffset"] = {
		xTexels = 16,
		yTexels = 16
	},

	["filter.colorMatrix"] = {
		coefficients = {
			0, 0, 1, 0,  -- Red coefficients
			0, 0, 1, 0,  -- Green coefficients
			0, 1, 0, 0,  -- Blue coefficients
			0, 0, 0, 1   -- Alpha coefficients
		},
		bias = { 0.9, 0.3, 0, 1 }
	},

	["filter.colorPolynomial"] = {
		coefficients = {
			0, 1, 1, 0,  -- Red coefficients
			0, 0, 1, 0,  -- Green coefficients
			0, 1, 0, 0,  -- Blue coefficients
			0, 0, 0, 1   -- Alpha coefficients
		}
	},

	["filter.contrast"] = {
		contrast = 3
	},

	["filter.crosshatch"] = {
		grain = 6
	},

	["filter.crystallize"] = {
		numTiles = 24,
		reqhp = true
	},

	["filter.desaturate"] = {
		intensity = 0.7
	},

	["filter.dissolve"] = {
		threshold = 0.5,
		reqhp = true
	},

	["filter.duotone"] = {
		darkColor = { 0.8, 0.2, 0.2, 1 },
		lightColor = { 1, 0.4, 0.4, 1 }
	},

	["filter.emboss"] = {
		intensity = 0.2
	},

	["filter.exposure"] = {
		exposure = 1.2
	},

	["filter.frostedGlass"] = {
		scale = 140,
		reqhp = true
	},

	["filter.grayscale"] = {},

	["filter.hue"] = {
		angle = 140,
		reqhp = true
	},

	["filter.invert"] = {},

	["filter.iris"] = {
		center = { 0.5, 0.5 },
		aperture = 0.5,
		aspectRatio = 1.25,
		smoothness = 0.5
	},

	["filter.levels"] = {
		white = 0.5,
		black = 0.1,
		gamma = 1
	},

	["filter.linearWipe"] = {
		direction = { 1, 1 },
		smoothness = 1,
		progress = 0.5
	},

	["filter.median"] = {},

	["filter.monotone"] = {
		r = 1,
		g = 0.2,
		b = 0.6,
		a = 0.6
	},

	["filter.opTile"] = {
		numPixels = 4,
		angle = 0,
		scale = 3
	},

	["filter.pixelate"] = {
		numPixels = 2
	},

	["filter.polkaDots"] = {
		numPixels = 8,
		dotRadius = 1,
		aspectRatio = 1.25
	},

	["filter.posterize"] = {
		colorsPerChannel = 4
	},

	["filter.radialWipe"] = {
		center = { 0.5, 0.5 },
		smoothness = 1,
		axisOrientation = 0,
		progress = 0.5
	},

	["filter.saturate"] = {
		intensity = 2.5
	},

	["filter.scatter"] = {
		intensity = 0.5,
		reqhp = true
	},

	["filter.sepia"] = {
		intensity = 1
	},

	["filter.sharpenLuminance"] = {
		sharpness = 1
	},

	["filter.sobel"] = {},

	["filter.straighten"] = {
		width = 10,
		height = 15,
		angle = 20
	},

	["filter.swirl"] = {
		intensity = 0.4
	},
	
	["filter.vignette"] = {
		radius = 0.1
	},
	
	["filter.vignetteMask"] = {
		innerRadius = 0.4,
		outerRadius = 0.1
	},
	
	["filter.wobble"] = {
		amplitude = 5
	},

	["filter.woodCut"] = {
		intensity = 0.4
	},

	["filter.zoomBlur"] = {
		u = 0.5,
		v = 0.5,
		intensity = 0.5
	}
}

return M
