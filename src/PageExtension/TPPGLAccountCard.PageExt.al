/// <summary>
/// PageExtension TPP GLAccount Card (ID 70507) extends Record G/L Account Card.
/// </summary>
pageextension 70507 "TPP GLAccount Card" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("TPP Deposit"; rec."TPP Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit';
            }
        }
    }
}