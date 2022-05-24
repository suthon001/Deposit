

/// <summary>
/// TableExtension DSVC Sales Invoice Line (ID 70507) extends Record Sales Invoice Line.
/// </summary>
tableextension 70507 "DSVC Sales Invoice Line" extends "Sales Invoice Line"
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