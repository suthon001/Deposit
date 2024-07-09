/// <summary>
/// PageExtension TPP Customer FactBox (ID 70504) extends Record Customer Statistics FactBox.
/// </summary>
pageextension 70504 "TPP Customer FactBox" extends "Customer Statistics FactBox"
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
