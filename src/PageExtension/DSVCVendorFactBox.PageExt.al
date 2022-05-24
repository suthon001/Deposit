
/// <summary>
/// PageExtension DSVC Vendor FactBox (ID 70510) extends Record Vendor Statistics FactBox.
/// </summary>
pageextension 70510 "DSVC Vendor FactBox" extends "Vendor Statistics FactBox"
{
    layout
    {
        addafter("Balance (LCY)")
        {
            field("DSVC Deposit Amount (LCY)"; rec."DSVC Deposit Amount (LCY)")
            {
                ToolTip = 'Show Summary Deposit Amount (LCY)';
                ApplicationArea = all;
            }
        }
    }
}
