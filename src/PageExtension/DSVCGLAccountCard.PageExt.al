/// <summary>
/// PageExtension DSVC GLAccount Card (ID 70507) extends Record G/L Account Card.
/// </summary>
pageextension 70507 "DSVC GLAccount Card" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("DSVC Deposit"; rec."DSVC Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit';
            }
        }
    }
}