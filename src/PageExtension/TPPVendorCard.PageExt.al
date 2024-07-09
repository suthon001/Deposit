/// <summary>
/// PageExtension TPP Vendor Card (ID 70505) extends Record Vendor Card.
/// </summary>
pageextension 70505 "TPP Vendor Card" extends "Vendor Card"
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