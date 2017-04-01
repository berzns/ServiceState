function Set-ServiceState
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        # <!<SnippetParam1Help>!>
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $CSVLocation = "C:\Temp\Services-test.csv",

        # <!<SnippetParam2Help>!>
        [int]$TryCount = 5)

        Begin
        {
			# Test if file exists



			if (Test-Path $CSVLocation)
			{
				write-host "Importing CSV file" -BackgroundColor Green
			}
			else
			{
				Write-Host "Check if CSV file $CSVLocation  exist!!!" -ForegroundColor Red
				break
			}

			# imports CSV file
			$DashBoard = Import-Csv -Path $CSVLocation

			# Build a list of server names
			$ServerList = $DashBoard.'Server name' | Select-Object -Unique

			# Opens an empty arry for storing information about services that failed to return to origional state
			$ServiceStatus = @()
          
        }

        Process
        {
          foreach ($Server in $ServerList) {

			Write-Verbose "Working on $Server" -Verbose

			# Builds a service list per server
			$ServiceList = $DashBoard | Where-Object {$_.'Server name' -EQ $Server}

			# loops thrugh each service and trys to return it to origional state
			foreach ($Service in $ServiceList) {

			# Removes " that are around service name.    
			$Srvc = $Service.'Service Name' -replace '"',""

					# making sure that the service is in desired state as in CSV file
					If ((Get-Service -ComputerName $Server -Name $Srvc).Status -eq $Service.Status) {
							Write-Host Service $Srvc on $Server is in its correct state $Service.Status

						} Else {
							if ($Service.Status -eq 'Running')
							{
								Write-Host Service $Srvc on $Server is in WRONG state. Should be $Service.Status -BackgroundColor DarkRed
								Write-Host Starting $Srvc on $Server. -BackgroundColor DarkGreen
                            
										$i=1
										Do {
											Write-Host Try $i : Starting $Srvc on $Server. -BackgroundColor DarkGreen
											Get-Service -ComputerName $Server -Name $Srvc | Start-Service -ErrorVariable ErrorMessage -ErrorAction SilentlyContinue ; $i++}
										Until ($i -gt $TryCount -or (Get-Service -ComputerName $Server -Name $Srvc).status -eq $Service.Status)
                                
										If ($i -gt $TryCount) {
                          

										Write-Host "Failed to start $Srvc on $Server with error message: $ErrorMessage"


										$ObjServiceStatus = New-Object System.Object
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServerName -value $Server
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceName -value $Service.'Service Name'
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServieeSatus -value (Get-Service -ComputerName $Server -Name $Srvc).status
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceShouldBe -value $Service.Status


										$ServiceStatus += $ObjServiceStatus




										}
                       




							} else {
								Write-Host Service $Srvc on $Server is in WRONG state. Should be $Service.Status -BackgroundColor DarkRed
								Write-Host Stopping $Srvc on $Server. -BackgroundColor DarkGreen
                        

								$i=1
										Do {
											Write-Host Try $i : Stopping $Srvc on $Server. -BackgroundColor DarkGreen
											Get-Service -ComputerName $Server -Name $Srvc | Stop-Service -ErrorVariable ErrorMessage -ErrorAction SilentlyContinue ; $i++}
										Until ($i -gt $TryCount -or (Get-Service -ComputerName $Server -Name $Srvc).status -eq $Service.Status)
                                
										If ($i -gt $TryCount) {
                          

										Write-Host "Failed to stop $Srvc on $Server with error message: $ErrorMessage"


										$ObjServiceStatus = New-Object System.Object
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServerName -value $Server
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceName -value $Service.'Service Name'
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServieeSatus -value (Get-Service -ComputerName $Server -Name $Srvc).status
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceShouldBe -value $Service.Status


										$ServiceStatus += $ObjServiceStatus



							}
                
							}
							}

				}



		}
        }

        End
        {
			
            If(!([string]::IsNullOrEmpty($ServiceStatus))) {

                Write-Host "The following list contains servers and services that failed to return to origional state " -BackgroundColor Red
                Write-Host "Services with empty ServiceSatus property do not exist " -BackgroundColor Red
                Write-host ($ServiceStatus |Format-Table | Out-String )
				
				<##
                $MissingServices= @()

                foreach($ServiceStatusResult in $ServiceStatus){

                If (![string]::IsNullOrEmpty($ServiceStatusResult.ServerName) -and ![string]::IsNullOrEmpty($ServiceStatusResult.ServiceName) -and [string]::IsNullOrEmpty($ServiceStatusResult.ServiceStatus)){

                						$ObjMissingService = New-Object System.Object
										$ObjMissingService | Add-Member -type NoteProperty -name ServerName -value $ServiceStatusResult.ServerName
										$ObjMissingService | Add-Member -type NoteProperty -name ServiceName -value $ServiceStatusResult.ServiceName

										$MissingServices += $ObjMissingService
										##>
                
                }



                
                #Write-Host "The following services do not exist" -BackgroundColor Red
                #Write-host ($MissingServices |Format-Table | Out-String )


               else {
              
              Write-Host Services are in desired state! Have a good day! -ForegroundColor Green
              }

			
        }
}


function Get-ServiceState
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        # <!<SnippetParam1Help>!>
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $CSVLocation = "C:\Temp\PreProd01_Services.csv",

        # <!<SnippetParam2Help>!>
        [int]$TryCount = 5)

        Begin
        {
			# Test if file exists

			if (Test-Path $CSVLocation)
			{
				write-host "Importing CSV file" -BackgroundColor DarkCyan
			}
			else
			{
				Write-Host "Check if CSV file $CSVLocation  exist!!!" -ForegroundColor Red
				break
			}

			# imports CSV file
			$DashBoard = Import-Csv -Path $CSVLocation

			# Build a list of server names
			$ServerList = $DashBoard.'Server name' | Select-Object -Unique

			# Opens an empty arry for storing information about services that failed to return to origional state
			$ServiceStatus = @()
          
        }

        Process
        {
          foreach ($Server in $ServerList) {

			Write-Verbose "Working on $Server" -Verbose

			# Builds a service list per server
			$ServiceList = $DashBoard | Where-Object {$_.'Server name' -EQ $Server}

			# loops thrugh each service and trys to return it to origional state
			foreach ($Service in $ServiceList) {

			# Removes " that are around service name.    
			$Srvc = $Service.'Service Name' -replace '"',""

					# making sure that the service is in desired state as in CSV file
                
                    # Get service state for the incoming service
					Try {
                    	$LiveServiceState = Get-Service -ComputerName $Server -Name $Srvc -ErrorAction Continue

					}
					Catch {
						Write-Verbose ( "There was an error {0} : {1}" -f $_.Exception.GetType(), $_.Exception.Message )
						Continue
					}

					If (!($LiveServiceState.Status -eq $Service.Status -and ($LiveServiceState).status.count -ge 1)) {
							Write-Host Service $Srvc on $Server is in WRONG state. Should be $Service.Status -BackgroundColor DarkRed

                          

										$ObjServiceStatus = New-Object System.Object
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServerName -value $Server
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceName -value $Service.'Service Name'
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceSatus -value ($LiveServiceState).status
										$ObjServiceStatus | Add-Member -type NoteProperty -name ServiceShouldBe -value $Service.Status


										$ServiceStatus += $ObjServiceStatus
            



							} else {
                    
                        $SrvcStatus = $Service.Status
                        Write-Verbose -Message "Service $Srvc on $Server is in its correct state $SrvcStatus"
                    }
                    
                    

				}



		}
        }

        End
        {
			
            If(!([string]::IsNullOrEmpty($ServiceStatus))) {

                Write-Host "The following services are in the wrong state " -BackgroundColor Red
                Write-Host "Services with empty ServiceSatus property do not exist " -BackgroundColor Red
                Write-host ($ServiceStatus |Format-Table | Out-String )

				<##

                $MissingServices= @()

                foreach($ServiceStatusResult in $ServiceStatus){

                If (![string]::IsNullOrEmpty($ServiceStatusResult.ServerName) -and ![string]::IsNullOrEmpty($ServiceStatusResult.ServiceName) -and [string]::IsNullOrEmpty($ServiceStatusResult.ServiceStatus)){

                						$ObjMissingService = New-Object System.Object
										$ObjMissingService | Add-Member -type NoteProperty -name ServerName -value $ServiceStatusResult.ServerName
										$ObjMissingService | Add-Member -type NoteProperty -name ServiceName -value $ServiceStatusResult.ServiceName

										$MissingServices += $ObjMissingService
										##>
                
                



                
                #Write-Host "The following services do not exist" -BackgroundColor Red
                #Write-host ($MissingServices |Format-Table | Out-String )


              } else {
              
              Write-Host Services are in desired state! Have a good day! -ForegroundColor Green
              }

			
        }
}