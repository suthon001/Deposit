/// <summary>
/// PageExtension DSVC Vendor Card (ID 70505) extends Record Vendor Card.
/// </summary>
pageextension 70505 "DSVC Vendor Card" extends "Vendor Card"
{
    layout
    {
        addbefore("Balance (LCY)")
        {
            field("DSVC Deposit Amount"; rec."DSVC Deposit Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Amount';
            }
            field("DSVC Deposit Amount (LCY)"; rec."DSVC Deposit Amount (LCY)")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Amount (LCY)';
            }
        }
    }
}