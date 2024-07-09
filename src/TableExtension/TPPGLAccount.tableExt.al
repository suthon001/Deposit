/// <summary>
/// TableExtension TPP GL Account (ID 70500) extends Record G/L Account.
/// </summary>
tableextension 70500 "TPP GL Account" extends "G/L Account"
{
    fields
    {
        field(70500; "TPP Deposit"; Boolean)
        {
            Caption = 'Deposit';
            DataClassification = CustomerContent;
        }
    }
}