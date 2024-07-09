
/// <summary>
/// TableExtension TPP Purchase CN Line (ID 70505) extends Record Purch. Cr. Memo Line.
/// </summary>
tableextension 70505 "TPP Dep. Purchase CN Line" extends "Purch. Cr. Memo Line"
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