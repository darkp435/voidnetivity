export type Permission = "blisted" | "none" | "user" | "maint" | "dev" | "admin" | "root"

local Permissions: {[string]: Permission} = {
	Blacklisted = "blisted",
	None = "none",
	User = "user",
	Maintainer = "maint",
	Developer = "dev",
	Admin = "admin",
	Root = "root"
}

table.freeze(Permissions)

return Permissions