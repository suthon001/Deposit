/// <summary>
/// TableExtension DSVC Genjournal Line (ID 70501) extends Record Gen. Journal Line.
/// </summary>
tableextension 70501 "DSVC Genjournal Line" extends "Gen. Journal Line"
{
    fields
    {

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
                        "DSVC Deposit" := GLAccount."DSVC Deposit";
                        "DSVC Deposit Type" := "DSVC Deposit Type"::" ";
                        "DSVC Deposit Type No." := '';
                        "DSVC From Genjournal Line" := "DSVC Deposit" = true;
                        if "DSVC Deposit" then begin
                            if GenJournalTemplate.Type = GenJournalTemplate.Type::Payments then
                                "DSVC Deposit Type" := "DSVC Deposit Type"::Vendor;
                            if GenJournalTemplate.Type = GenJournalTemplate.Type::"Cash Receipts" then
                                "DSVC Deposit Type" := "DSVC Deposit Type"::Customer;
                        end;
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