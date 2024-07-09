/// <summary>
/// Enum TPP Deposit Type (ID 70500).
/// </summary>
enum 70500 "TPP Deposit Type"
{
    value(1; "Sales Invoice") { Caption = 'Sales Invoice'; }
    value(2; "Sales Credit Memo") { Caption = 'Sales Credit Memo'; }
    value(3; "Purchase Invoice") { Caption = 'Purchase Invoice'; }
    value(4; "Purchase Credit Memo") { Caption = 'Purchase Credit Memo'; }
    value(5; "Payment Journal") { Caption = 'Payment Journal'; }
    value(6; "Cash Receipt") { Caption = 'Cash Receipt'; }

}