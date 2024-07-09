/// <summary>
/// Enum TPP Deposit Type (ID 70501).
/// </summary>
enum 70501 "TPP Deposit Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Customer)
    {
        Caption = 'Customer';
    }
    value(2; Vendor)
    {
        Caption = 'Vendor';
    }
}
