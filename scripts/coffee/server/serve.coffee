path = require 'path'

module.exports = serve = (root, lanesDir, port, passes, log) ->

	repoPath = path.join path.dirname(module.parent.filename), root

	require('theatrejs').serve repoPath, 6543, lanesDir, passes, log