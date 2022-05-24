
/// <summary>
/// TableExtension DSVC Vendor (ID 70511) extends Record Vendor.
/// </summary>
tableextension 70511 "DSVC Vendor" extends Vendor
{
    fields
    {
        field(70500; "DSVC Deposit Amount"; Decimal)
        {
            Caption = 'Deposit Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("DSVC Deposit Entry".Amount where("Customer/Vendor No." = field("No.")));
        }
        field(70501; "DSVC Deposit Amount (LCY)"; Decimal)
        {
            Caption = 'Deposit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("DSVC Deposit Entry"."Amount (LCY)" where("Customer/Vendor No." = field("No.")));
        }
    }
}