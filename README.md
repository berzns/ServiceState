# ServiceState
## PS module to retun windows services on remote machines to the states as specified in the input CSV file.
---
### Example 1
    Get-ServiceState -CSVLocation "C:\Temp\Services-test.csv"  -TryCount 5

Output

    Importing CSV file
    VERBOSE: Working on APP-PP1A
    Service Service.BillingCancellationsService on APP-PP1A is in WRONG state. Should be Stopped
    VERBOSE: Working on APP-PP1B
    Service Service.PaymentResultService on APP-PP1B is in WRONG state. Should be Stopped
    Service Service.PaymentResultServiceSecondary on APP-PP1B is in WRONG state. Should be Stopped
    VERBOSE: Working on APP-PP1E

    The following services are in the wrong state
    Services with empty ServiceSatus property do not exist

    ServerName      ServiceName                                      ServiceSatus ServiceShouldBe
    ----------      -----------                                      ------------ ---------------
    APP-PP1A  Service.BillingCancellationsService              Running Stopped
    APP-PP1B  Service.PaymentResultService                     Running Stopped
    APP-PP1B  Service.PaymentResultServiceSecondary            Running Stopped
    APP-PP1F  Search.Data.Export.Windows.Services.DE           Running Stopped
    APP-PP1F  Search.Data.Transfer.Windows.Services.DE         Running Stopped
    APP-PP1F  Search.Data.Transfer.Windows.Services.UK         Running Stopped
    APP-PP1F  Search.Data.Transfer.Windows.Services.US         Running Stopped
    APP-PP1F  Search.Data.Translation.Windows.Services.DE      Running Stopped
    APP-PP1F  Search.Data.Translation.Windows.Services.US      Running Stopped
    NBUS-PP1D Commerce.Orders.Legacy.Endpoint                          Stopped
    NBUS-PP1E Commerce.Orders.Legacy.Endpoint                          Stopped

Set-ServiceState -CSVLocation "C:\Temp\Services-test.csv"
### Set-ServiceState

