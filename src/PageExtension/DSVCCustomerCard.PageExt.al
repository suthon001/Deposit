
/// <summary>
/// PageExtension DSVC Customer Card (ID 70506) extends Record Customer Card.
/// </summary>
pageextension 70506 "DSVC Customer Card" extends "Customer Card"
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