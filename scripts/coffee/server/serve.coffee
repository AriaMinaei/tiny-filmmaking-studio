path = require 'path'

module.exports = serve = (root, lanesDir, port, passphrase, log) ->

	repoPath = path.join path.dirname(module.parent.filename), root

	require('theatrejs').serve repoPath, port, lanesDir, passphrase, log