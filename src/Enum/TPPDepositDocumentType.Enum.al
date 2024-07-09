/// <summary>
/// Enum TPP Deposit Type (ID 70500).
/// </summary>
enum 70500 "TPP Deposit Document Type"
{
    value(0; "Sales Invoice") { Caption = 'Sales Invoice'; }
    value(1; "Sales Credit Memo") { Caption = 'Sales Credit Memo'; }
    value(2; "Purchase Invoice") { Caption = 'Purchase Invoice'; }
    value(3; "Purchase Credit Memo") { Caption = 'Purchase Credit Memo'; }
    value(4; "Payment Journal") { Caption = 'Payment Journal'; }
    value(5; "Cash Receipt") { Caption = 'Cash Receipt'; }

}