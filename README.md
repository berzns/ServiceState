# ServiceState
## PS module to retun windows services on remote machines to the states as specified in the input CSV file.

### Example 1
Get-ServiceState -CSVLocation "C:\Temp\Services-test.csv"  -TryCount 5

Set-ServiceState -CSVLocation "C:\Temp\Services-test.csv"
### Set-ServiceState

