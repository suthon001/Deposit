
/// <summary>
/// TableExtension DSVC Purchase CN Line (ID 70505) extends Record Purch. Cr. Memo Line.
/// </summary>
tableextension 70505 "DSVC Purchase CN Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(70500; "DSVC Deposit"; Boolean)
        {
            Caption = 'Deposit';
            DataClassification = CustomerContent;
        }
        field(70501; "DSVC Clear Deposit"; Boolean)
        {
            Caption = 'Clear Deposit';
            DataClassification = CustomerContent;
        }
        field(70502; "DSVC Ref. Deposit Entry No."; Integer)
        {
            Caption = 'Ref. Deposit Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
}