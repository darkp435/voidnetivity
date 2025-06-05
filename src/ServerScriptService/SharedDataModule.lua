local module = {}
module.Data = {} -- this is where the actual data is

function module.hasAccessTo(userid, hostname)
	return module.Data[userid]["hostinfo"][hostname] == "none"
end

function module.getFilesFrom(userid, hostname)
	return module.Data[userid]["hostinfo"][hostname]["files"]
end

function module.getPerms(userid, hostname)
	return module.Data[userid]["hostinfo"][hostname]["permission"]
end

function module.addFile(userid, hostname, filename)
	table.insert(module.Data[userid]["hostinfo"][hostname]["files"], filename)
end

function module.getSysadm(userid)
	return module.Data[userid]["hasSysadm"]
end

function module.isFirstTimeJoining(userid)
	return module.Data[userid]["firstTimeJoining"]
end

function module.getDaemons(userid)
	return module.Data[userid]["daemons"]
end

return module