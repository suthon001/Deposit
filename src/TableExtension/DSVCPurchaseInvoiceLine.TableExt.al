/// <summary>
/// TableExtension DSVC Purchase Invoice Line (ID 70504) extends Record Purchase Invoice Line.
/// </summary>
tableextension 70504 "DSVC Purchase Invoice Line" extends "Purch. Inv. Line"
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