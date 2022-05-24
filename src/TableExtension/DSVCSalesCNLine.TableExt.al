
/// <summary>
/// TableExtension DSVC Sales CN Line (ID 70506) extends Record Sales Cr.Memo Line.
/// </summary>
tableextension 70506 "DSVC Sales CN Line" extends "Sales Cr.Memo Line"
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