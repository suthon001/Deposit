
/// <summary>
/// PageExtension TPP Customer Card (ID 70506) extends Record Customer Card.
/// </summary>
pageextension 70506 "TPP Customer Card" extends "Customer Card"
{
    layout
    {
        addbefore("Balance (LCY)")
        {
            field("TPP Deposit Amount"; rec."TPP Deposit Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Amount';
            }
            field("TPP Deposit Amount (LCY)"; rec."TPP Deposit Amount (LCY)")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Amount (LCY)';
            }
        }
    }
}