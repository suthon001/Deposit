/// <summary>
/// TableExtension DSVC Purchase Line (ID 70502) extends Record Purchase Line.
/// </summary>
tableextension 70502 "DSVC Purchase Line" extends "Purchase Line"
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
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        PurchaseLine.SetRange("DOcument Type", "DOcument Type");
        PurchaseLine.SetRange("Document No.", "Document No.");
        if PurchaseLine.FindLast() then
            exit(PurchaseLine."Line No." + 10000);
        exit(10000);
    end;
}