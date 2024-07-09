
/// <summary>
/// Page TPP Get Deposit Entry (ID 70501).
/// </summary>
Page 70501 "TPP Get Deposit Entry"
{
    Caption = 'Get Deposit Entry';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "TPP Deposit Entry";
    SourceTableView = sorting("Entry No.") where(Used = filter(false), "Clear Deposit" = filter(false));
    UsageCategory = None;
    PageType = List;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Document Type';
                }
                field("G/L Account No."; rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies G/L Account No.';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Posting Date';
                }
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Document Date';
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Document No.';
                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Customer/Vendor No.';
                }
                field("Customer/Vendor Name"; rec."Customer/Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Customer/Vendor Name';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies ';
                }
                field("External Document No."; rec."External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies External Document No.';
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Currency Code';
                }
                field("Vat Prod. Posting Group"; rec."Vat Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Vat Prod. Posting Group';
                }
                field("Vat Bus. Posting Group"; rec."Vat Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Vat Bus. Posting Group';
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount';
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount (LCY)';
                }
                field("Amount Include Vat"; rec."Amount Include Vat")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount Include Vat';
                }
                field("Amount Include Vat (LCY)"; rec."Amount Include Vat (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount Include Vat (LCY)';
                }

            }
        }
    }

    /// <summary>
    /// SetDepositDocument.
    /// </summary>
    /// <param name="pDepositType">Enum "TPP Deposit Type".</param>
    /// <param name="pTemplateName">Code[10].</param>
    /// <param name="pBatchName">code[30].</param>
    /// <param name="pDocumentNo">Code[30].</param>
    procedure SetDepositDocument(pDepositType: Enum "TPP Deposit Document Type"; pTemplateName: Code[10]; pBatchName: code[30]; pDocumentNo: Code[30])
    begin
        gvDepositType := pDepositType;
        gvTemplateName := pTemplateName;
        gvBatchName := pBatchName;
        gvdocumentNo := pDocumentNo;
        FromGenLine := false;

        if NOT (pDepositType in [pDepositType::"Payment Journal", pDepositType::"Cash Receipt"]) then begin
            if pDepositType IN [pDepositType::"Purchase Invoice", pDepositType::"Sales Invoice"] then
                documentType := documentType::Invoice
            else
                documentType := documentType::"Credit Memo";
        end else
            FromGenLine := true;

    end;

    local procedure CreateGenLine()
    begin
        DopositEntry.Copy(rec);
        CurrPage.SetSelectionFilter(DopositEntry);
        if DopositEntry.FindSet() then
            repeat

                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := COPYSTR(gvTemplateName, 1, 10);
                GenJournalLine."Journal Batch Name" := COPYSTR(gvBatchName, 1, 10);
                GenJournalLine."Line No." := GenJournalLine."TPP GetLastLine"();
                GenJournalLine."Document No." := COPYSTR(gvdocumentNo, 1, 20);
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.Insert(true);
                GenJournalLine."Posting Date" := WorkDate();
                GenJournalLine."Document Date" := WorkDate();
                GenJournalLine.Validate("Account No.", DopositEntry."G/L Account No.");
                GenJournalLine.Validate("VAT Prod. Posting Group", DopositEntry."Vat Prod. Posting Group");
                if gvDepositType = gvDepositType::"Payment Journal" then begin
                    GenJournalLine.Validate(Amount, ABS(DopositEntry.Amount) * -1);
                    GenJournalLine."TPP Deposit Type" := GenJournalLine."TPP Deposit Type"::Vendor;
                end else begin
                    GenJournalLine.Validate(Amount, ABS(DopositEntry.Amount));
                    GenJournalLine."TPP Deposit Type" := GenJournalLine."TPP Deposit Type"::Customer;
                end;
                GenJournalLine."TPP Clear Deposit" := true;
                GenJournalLine."TPP From Genjournal Line" := true;
                GenJournalLine."TPP Deposit Type No." := DopositEntry."Customer/Vendor No.";
                GenJournalLine."TPP Deposit" := true;
                GenJournalLine."TPP Ref. Deposit Entry No." := DopositEntry."Entry No.";
                GenJournalLine."External Document No." := DopositEntry."External Document No.";
                GenJournalLine.Modify();
                DopositEntry."Ref. Document Line No." := GenJournalLine."Line No.";
                DopositEntry."Ref. Batch Name" := GenJournalLine."Document No.";
                DopositEntry."Ref. Template Name" := GenJournalLine."Journal Template Name";
                DopositEntry.Used := true;
                DopositEntry.Modify();
            until DopositEntry.next() = 0;
    end;

    local procedure CreateSalesLine()
    begin
        DopositEntry.Copy(rec);
        CurrPage.SetSelectionFilter(DopositEntry);
        if DopositEntry.FindSet() then
            repeat

                SalesLine.Init();
                SalesLine."Document Type" := documentType;
                SalesLine."Document No." := COPYSTR(gvdocumentNo, 1, 20);
                SalesLine."Line No." := SalesLine."TPP GetLastLineDeposit"();
                SalesLine.type := SalesLine.type::"G/L Account";
                SalesLine.Insert(true);
                SalesLine.Validate("No.", DopositEntry."G/L Account No.");
                SalesLine.Validate("VAT Prod. Posting Group", DopositEntry."Vat Prod. Posting Group");
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", ABS(DopositEntry.Amount) * -1);
                SalesLine."TPP Clear Deposit" := true;
                SalesLine."TPP Deposit" := true;
                SalesLine."TPP Ref. Deposit Entry No." := DopositEntry."Entry No.";
                SalesLine.Modify();
                DopositEntry."Ref. Document Line No." := SalesLine."Line No.";
                DopositEntry."Ref. Batch Name" := SalesLine."Document No.";
                DopositEntry."Ref. Template Name" := Format(SalesLine."Document Type");
                DopositEntry.Used := true;
                DopositEntry.Modify();
            until DopositEntry.next() = 0;
    end;

    local procedure CreatePurchaseLine()
    begin
        DopositEntry.Copy(rec);
        CurrPage.SetSelectionFilter(DopositEntry);
        if DopositEntry.FindSet() then
            repeat

                PurchaseLine.Init();
                PurchaseLine."Document Type" := documentType;
                PurchaseLine."Document No." := COPYSTR(gvdocumentNo, 1, 20);
                PurchaseLine."Line No." := PurchaseLine."TPP GetLastLine"();
                PurchaseLine.type := PurchaseLine.type::"G/L Account";
                PurchaseLine.Insert(true);
                PurchaseLine.Validate("No.", DopositEntry."G/L Account No.");
                PurchaseLine.Validate("VAT Prod. Posting Group", DopositEntry."Vat Prod. Posting Group");
                PurchaseLine.Validate(Quantity, 1);
                PurchaseLine.Validate("Direct Unit Cost", ABS(DopositEntry.Amount) * -1);
                PurchaseLine."TPP Clear Deposit" := true;
                PurchaseLine."TPP Deposit" := true;
                PurchaseLine."TPP Ref. Deposit Entry No." := DopositEntry."Entry No.";
                PurchaseLine.Modify();
                DopositEntry."Ref. Document Line No." := PurchaseLine."Line No.";
                DopositEntry."Ref. Batch Name" := PurchaseLine."Document No.";
                DopositEntry."Ref. Template Name" := Format(PurchaseLine."Document Type");
                DopositEntry.Used := true;
                DopositEntry.Modify();
            until DopositEntry.next() = 0;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            if FromGenLine then
                CreateGenLine()
            else
                if gvDepositType IN [gvDepositType::"Sales Credit Memo", gvDepositType::"Sales Invoice"] then
                    CreateSalesLine()
                else
                    CreatePurchaseLine();

    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        DopositEntry: Record "TPP Deposit Entry";
        documentType: Enum "Purchase Document Type";
        gvDepositType: Enum "TPP Deposit Document Type";
        gvdocumentNo, gvTemplateName, gvBatchName : Code[30];

        FromGenLine: Boolean;


}