# ServiceState
## PS module to retun windows services on remote machines to the states as specified in the input CSV file.
### The CSV file has to be in the following format:

    "Service Name","Server Name","Status"
    "Service.BillingCancellationsService","APP-PP1A","Running"
    "Service.PaymentResultService","APP-PP1B","Running"
    "Service.PaymentResultServiceSecondary","APP-PP1B","Running"
    "Search.Data.Translation.Windows.Services.DE","APP-PP1F","Running"

---
### Example 1
    Get-ServiceState -CSVLocation "C:\Temp\Services-test.csv"  -Verbose
This command will check the service state and will retun a list of services that are not in desired state.


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

    ServerName      ServiceName                                 ServiceSatus    ServiceShouldBe
    ----------      -----------                                 ------------    ---------------
    APP-PP1A        Service.BillingCancellationsService               Running         Stopped
    APP-PP1F        Search.Data.Translation.Windows.Services.DE       Running         Stopped
    APP-PP1F        Search.Data.Translation.Windows.Services.US       Running         Stopped
    NBUS-PP1D       Commerce.Orders.Legacy.Endpoint                                   Stopped
    NBUS-PP1E       Commerce.Orders.Legacy.Endpoint                                   Stopped

### Example 2
    Set-ServiceState -CSVLocation "C:\Temp\Services-test.csv" -TryCount 2 -Verbose

Output

    Importing CSV file
    VERBOSE: Working on APP-PP1A
    Service Service.BillingCancellationsService on APP-PP1A is in WRONG state. Should be Stopped
    Stopping Service.BillingCancellationsService on APP-PP1A
    Try 1 : Stopping Service.BillingCancellationsService on APP-PP1A
    Try 2 : Stopping Service.BillingCancellationsService on APP-PP1A
    VERBOSE: Working on APP-PP1B
    Service Service.PaymentResultService on APP-PP1B is in WRONG state. Should be Stopped
    Stopping Service.PaymentResultService on APP-PP1B
    Try 1 : Stopping Service.PaymentResultService on APP-PP1B
    Try 2 : Stopping Service.PaymentResultService on APP-PP1B

    The following list contains servers and services that failed to return to origional state 

    ServerName  ServiceName                                     ServieeSatus    ServiceShouldBe
    ----------  -----------                                     ------------    ---------------
    APP-PP1A    Stopping Service.BillingCancellationsService                     Stopped        