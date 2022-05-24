/// <summary>
/// TableExtension DSVC GL Account (ID 70500) extends Record G/L Account.
/// </summary>
tableextension 70500 "DSVC GL Account" extends "G/L Account"
{
    fields
    {
        field(70500; "DSVC Deposit"; Boolean)
        {
            Caption = 'Deposit';
            DataClassification = CustomerContent;
        }
    }
}