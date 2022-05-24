/// <summary>
/// TableExtension DSVC Sales Line (ID 70503) extends Record Sales Line.
/// </summary>
tableextension 70503 "DSVC Sales Line" extends "Sales Line"
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
                    "DSVC Deposit" := GLAccount."DSVC Deposit";
                end;
            end;
        }
    }
    /// <summary>
    /// DSVC GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure "DSVC GetLastLine"(): Integer
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