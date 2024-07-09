
/// <summary>
/// PageExtension TPP Vendor FactBox (ID 70510) extends Record Vendor Statistics FactBox.
/// </summary>
pageextension 70510 "TPP Vendor FactBox" extends "Vendor Statistics FactBox"
{
    layout
    {
        addafter("Balance (LCY)")
        {
            field("TPP Deposit Amount (LCY)"; rec."TPP Deposit Amount (LCY)")
            {
                ToolTip = 'Show Summary Deposit Amount (LCY)';
                ApplicationArea = all;
            }
        }
    }
}
