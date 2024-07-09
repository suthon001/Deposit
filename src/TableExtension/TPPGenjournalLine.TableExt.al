/// <summary>
/// TableExtension TPP Genjournal Line (ID 70501) extends Record Gen. Journal Line.
/// </summary>
tableextension 70501 "TPP Genjournal Line" extends "Gen. Journal Line"
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
        field(70502; "TPP Deposit Type"; Enum "TPP Deposit Type")
        {
            Caption = 'Deposit Type';
        }
        field(70503; "TPP Deposit Type No."; code[20])
        {
            Caption = 'Deposit Type No.';
            TableRelation = if ("TPP Deposit Type" = const(customer)) customer else if ("TPP Deposit Type" = const(Vendor)) Vendor;
        }
        field(70504; "TPP From Genjournal Line"; Boolean)
        {
            Caption = 'From Genjournal Line';
        }
        field(70505; "TPP Ref. Deposit Entry No."; Integer)
        {
            Caption = 'Ref. Deposit Entry No.';
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                GLAccount: Record "G/L Account";
                GenJournalTemplate: Record "Gen. Journal Template";
            begin
                GenJournalTemplate.GET("Journal Template Name");
                if GenJournalTemplate.Type IN [GenJournalTemplate.Type::Payments, GenJournalTemplate.Type::"Cash Receipts"] then
                    if xRec."Account No." <> Rec."Account No." then begin
                        if "Account Type" = "Account Type"::"G/L Account" then
                            if not GLAccount.GET("Account No.") then
                                GLAccount.Init();
                        rec."TPP Deposit" := GLAccount."TPP Deposit";
                        rec."TPP Deposit Type" := rec."TPP Deposit Type"::" ";
                        rec."TPP Deposit Type No." := '';
                        rec."TPP From Genjournal Line" := rec."TPP Deposit" = true;
                        if "TPP Deposit" then begin
                            if GenJournalTemplate.Type = GenJournalTemplate.Type::Payments then
                                rec."TPP Deposit Type" := rec."TPP Deposit Type"::Vendor;
                            if GenJournalTemplate.Type = GenJournalTemplate.Type::"Cash Receipts" then
                                rec."TPP Deposit Type" := rec."TPP Deposit Type"::Customer;
                        end;
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
        GenLine: Record "Gen. Journal Line";
    begin
        GenLine.Reset();
        GenLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        GenLine.SetRange("Journal Template Name", "Journal Template Name");
        GenLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if GenLine.FindLast() then
            exit(GenLine."Line No." + 10000);
        exit(10000);
    end;

}