/// <summary>
/// PageExtension DSVC Customer FactBox (ID 70504) extends Record Customer Statistics FactBox.
/// </summary>
pageextension 70504 "DSVC Customer FactBox" extends "Customer Statistics FactBox"
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
