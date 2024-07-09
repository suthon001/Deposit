/// <summary>
/// TableExtension TPP Customer (ID 70510).
/// </summary>
tableextension 70510 "TPP Dep. Customer" extends Customer
{
    fields
    {
        field(70500; "TPP Deposit Amount"; Decimal)
        {
            Caption = 'Deposit Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPP Deposit Entry".Amount where("Customer/Vendor No." = field("No."), Type = const(Customer)));
        }
        field(70501; "TPP Deposit Amount (LCY)"; Decimal)
        {
            Caption = 'Deposit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("TPP Deposit Entry"."Amount (LCY)" where("Customer/Vendor No." = field("No."), Type = const(Customer)));
        }
    }
}