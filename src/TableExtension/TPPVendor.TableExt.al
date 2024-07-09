
/// <summary>
/// TableExtension TPP Vendor (ID 70511) extends Record Vendor.
/// </summary>
tableextension 70511 "TPP Dep. Vendor" extends Vendor
{
    fields
    {
        field(70500; "TPP Deposit Amount"; Decimal)
        {
            Caption = 'Deposit Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPP Deposit Entry".Amount where("Customer/Vendor No." = field("No."), Type = const(Vendor)));
        }
        field(70501; "TPP Deposit Amount (LCY)"; Decimal)
        {
            Caption = 'Deposit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("TPP Deposit Entry"."Amount (LCY)" where("Customer/Vendor No." = field("No."), Type = const(Vendor)));
        }
    }
}