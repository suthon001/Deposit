
/// <summary>
/// TableExtension TPP Sales CN Line (ID 70506) extends Record Sales Cr.Memo Line.
/// </summary>
tableextension 70506 "TPP Dep. Sales CN Line" extends "Sales Cr.Memo Line"
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