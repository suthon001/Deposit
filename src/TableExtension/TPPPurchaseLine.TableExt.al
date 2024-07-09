/// <summary>
/// TableExtension TPP Purchase Line (ID 70502) extends Record Purchase Line.
/// </summary>
tableextension 70502 "TPP Dep. Purchase Line" extends "Purchase Line"
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
    procedure "TPP GetLastLine"(): Integer
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