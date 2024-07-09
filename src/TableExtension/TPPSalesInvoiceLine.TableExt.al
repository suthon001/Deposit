

/// <summary>
/// TableExtension TPP Sales Invoice Line (ID 70507) extends Record Sales Invoice Line.
/// </summary>
tableextension 70507 "TPP Dep. Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(70500; "TPP Deposit"; Boolean)
        {
            Caption = 'Deposit';
            DataClassification = CustomerContent;
        }
        field(70501; "TPP Clear Deposit"; Boolean)
        {
            Caption = 'Clear Deposit';
            DataClassification = CustomerContent;
        }
        field(70502; "TPP Ref. Deposit Entry No."; Integer)
        {
            Caption = 'Ref. Deposit Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
}