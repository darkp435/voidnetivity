local FtpStatus = {
	Success = "success",
	BrokenPipe = "brokepipe",
	Interrupted = "interrupt",
	UnknownError = "unknown"
}

table.freeze(FtpStatus)

return FtpStatus