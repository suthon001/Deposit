/// <summary>
/// TableExtension TPP Sales Line (ID 70503) extends Record Sales Line.
/// </summary>
tableextension 70503 "TPP Dep. Sales Line" extends "Sales Line"
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
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                GLAccount: Record "G/L Account";
            begin
                if xRec."No." <> Rec."No." then begin
                    if "Type" = "Type"::"G/L Account" then
                        if not GLAccount.GET("No.") then
                            GLAccount.Init();
                    "TPP Deposit" := GLAccount."TPP Deposit";
                end;
            end;
        }
    }
    /// <summary>
    /// TPP GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure "TPP GetLastLineDeposit"(): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        SalesLine.SetRange("DOcument Type", "DOcument Type");
        SalesLine.SetRange("Document No.", "Document No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);
        exit(10000);
    end;

}