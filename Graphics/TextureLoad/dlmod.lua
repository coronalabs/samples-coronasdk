
local function fileDownload( rootURL, fileList, listener )

	local filesToDownload = {}
	local totalBytes = 0
	local bytesDownloaded = 0

	local function reportStatus( message, isError, progress, done )
		listener{ message=message, isError=isError, progress=progress, done=done }
	end

	-- Download next file and report status back to listener
	local function downloadNextFile()

		-- If all files are downloaded, report success and exit
		if ( #filesToDownload == 0 ) then
			reportStatus( "complete!", false, 1, true )
			return
		end

		-- Get next file to download, concatenate URL, and get file size
		local nextFileTable = table.remove( filesToDownload, 1 )
		local nextFile = nextFileTable[1]
		local fileURL = rootURL .. nextFileTable[1]
		local fileSize = nextFileTable[2]

		-- Download listener
		local function downloadListener( event )

			if ( event.isError or event.status == 404 ) then
				-- Error; interrupt process
				reportStatus( 'error downloading "' .. nextFile .. '"', true, 0 )
			elseif ( event.phase == "progress" ) then
				-- Progress; report file download progress
				reportStatus( 'downloading "' .. nextFile .. '"', false, (bytesDownloaded+event.bytesTransferred)/totalBytes )
			elseif ( event.phase == "ended" ) then
				-- Success; download finished, move to next file
				bytesDownloaded = bytesDownloaded + event.bytesTransferred
				downloadNextFile()
			end
		end

		-- Initiate file download
		network.download( fileURL, "GET", downloadListener, { progress=true }, nextFile, system.CachesDirectory )
	end

	-- Loop through file list and calculate total bytes + file status
	for f = 1,#fileList do
		totalBytes = totalBytes + fileList[f]["fileSize"]
		if ( fileList[f]["exists"] == false ) then
			filesToDownload[#filesToDownload+1] = { fileList[f]["file"], fileList[f]["fileSize"] }
		elseif ( fileList[f]["exists"] == true ) then
			bytesDownloaded = bytesDownloaded + fileList[f]["fileSize"]
		end
	end
	
	-- Call file download function
	downloadNextFile()
end

return { download=fileDownload }
