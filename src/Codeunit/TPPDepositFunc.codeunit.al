/// <summary>
/// Codeunit TPP Deposit Func (ID 70500).
/// </summary>
codeunit 70500 "TPP Deposit Func"
{

    /// <summary>
    /// GetDepositEntry.
    /// </summary>
    /// <param name="pDepositType">Enum "TPP Deposit Type".</param>
    /// <param name="pTemplateName">Code[10].</param>
    /// <param name="pDocumentNo">Code[30].</param>
    /// <param name="pVendorCoustomerNo">Code[20].</param>
    /// <param name="pBatchName">code[30].</param>

    procedure GetDepositEntry(pDepositType: Enum "TPP Deposit Document Type"; pTemplateName: Code[10]; pDocumentNo: Code[30]; pVendorCoustomerNo: Code[20]; pBatchName: code[30])
    var
        DepositEntry: Record "TPP Deposit Entry";
        GetDeposit: Page "TPP Get Deposit Entry";
    begin
        CLEAR(GetDeposit);
        DepositEntry.Reset();
        DepositEntry.SetRange("Customer/Vendor No.", pVendorCoustomerNo);
        DepositEntry.SetRange(Used, false);
        DepositEntry.SetRange("Clear Deposit", false);
        // if pDepositType = pDepositType::"Payment Journal" then
        //     DepositEntry.setrange("Document Type", DepositEntry."Document Type"::"Purchase Invoice");
        // if pDepositType = pDepositType::"Cash Receipt" then
        //     DepositEntry.setrange("Document Type", DepositEntry."Document Type"::"Sales Invoice");
        // if pDepositType = pDepositType::"Purchase Invoice" then
        //     DepositEntry.setrange("Document Type", DepositEntry."Document Type"::"Payment Journal");
        // if pDepositType = pDepositType::"Sales Invoice" then
        //     DepositEntry.setrange("Document Type", DepositEntry."Document Type"::"Cash Receipt");
        GetDeposit.Editable := false;
        GetDeposit.SetTableView(DepositEntry);
        GetDeposit.SetDepositDocument(pDepositType, pTemplateName, pBatchName, pDocumentNo);
        GetDeposit.LookupMode := TRUE;
        GetDeposit.RunModal();
        CLEAR(GetDeposit);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCode', '', false, false)]
    local procedure TPPOnBeforeCode(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenLine: Record "Gen. Journal Line";

    begin
        GenLine.Reset();
        GenLine.copy(GenJnlLine);
        GenLine.SetRange("TPP Deposit", true);
        GenLine.SetRange("TPP From Genjournal Line", true);
        if GenLine.FindSet() then
            repeat
                GenLine.TestField("TPP Deposit Type No.");
            until GenLine.next() = 0;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure TPPOnAfterInitFromPurchInvoiceLine(PurchLine: Record "Purchase Line")

    begin
        "TPP CreateDepositPurchaseEntry"(PurchLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Cr. Memo Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure TPPOnAfterInitFromPurchCNLine(PurchLine: Record "Purchase Line")

    begin
        "TPP CreateDepositPurchaseEntry"(PurchLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure TPPOnAfterInitFromSalesInvoiceLine(SalesLine: Record "Sales Line")

    begin
        "TPP CreateDepositSalesEntry"(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesCNLine(SalesLine: Record "Sales Line")

    begin
        "TPP CreateDepositSalesEntry"(SalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeUpdateAndDeleteLines', '', false, false)]
    local procedure TPPOnBeforeUpdateAndDeleteLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        DepositEntry: Record "TPP Deposit Entry";
        GenjournalTemplate: Record "Gen. Journal Template";
        Vend: Record Vendor;
        Cust: Record Customer;
        ExchangeCurrency: Record "Currency Exchange Rate";

    begin
        GenjournalTemplate.GET(GenJournalLine."Journal Template Name");
        GenJnlLine.Reset();
        GenJnlLine.Copy(GenJournalLine);
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        GenJnlLine.SetRange("TPP Deposit", true);
        if GenJnlLine.FindSet() then
            repeat
                DepositEntry.Init();
                DepositEntry."Entry No." := DepositEntry."TPP GetLastLine"();
                DepositEntry."Document No." := GenJnlLine."Document No.";
                DepositEntry."G/L Account No." := GenJnlLine."Account No.";
                if NOT GenJnlLine."TPP Clear Deposit" then begin
                    DepositEntry.Amount := GenJnlLine.Amount - GenJnlLine."VAT Amount";
                    DepositEntry."Amount Include Vat" := GenJnlLine.Amount;
                    DepositEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)" - GenJnlLine."VAT Amount (LCY)";
                    DepositEntry."Amount Include Vat (LCY)" := GenJnlLine."Amount (LCY)";
                end else begin
                    DepositEntry.Amount := (GenJnlLine.Amount - GenJnlLine."VAT Amount") * -1;
                    DepositEntry."Amount Include Vat" := (GenJnlLine.Amount) * -1;
                    DepositEntry."Amount (LCY)" := (GenJnlLine."Amount (LCY)" - GenJnlLine."VAT Amount (LCY)") * -1;
                    DepositEntry."Amount Include Vat (LCY)" := (GenJnlLine."Amount (LCY)") * -1;
                end;
                DepositEntry."Posting Date" := GenJnlLine."Posting Date";
                DepositEntry."Document Date" := GenJnlLine."Document Date";
                DepositEntry."External Document No." := GenJnlLine."External Document No.";
                DepositEntry."Ref. Document Line No." := GenJnlLine."Line No.";
                DepositEntry."Vat Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
                DepositEntry."Vat Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
                if GenjournalTemplate.Type = GenjournalTemplate.Type::"Cash Receipts" then
                    DepositEntry."Document Type" := DepositEntry."Document Type"::"Cash Receipt";
                if GenjournalTemplate.Type = GenjournalTemplate.Type::Payments then
                    DepositEntry."Document Type" := DepositEntry."Document Type"::"Payment Journal";
                if GenJnlLine."TPP Deposit Type" = GenJnlLine."TPP Deposit Type"::Vendor then begin
                    Vend.GET(GenJnlLine."TPP Deposit Type No.");
                    DepositEntry."Customer/Vendor Name" := Vend.Name;
                    if Vend."Currency Code" <> '' then
                        DepositEntry."Currency Factor" := ExchangeCurrency.ExchangeRate(DepositEntry."Posting Date", Vend."Currency Code");
                    //  DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * (1 / DepositEntry."Currency Factor");
                    //   DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * (1 / DepositEntry."Currency Factor");

                    DepositEntry."Currency Code" := Vend."Currency Code";
                end else begin
                    Cust.GET(GenJnlLine."TPP Deposit Type No.");
                    DepositEntry."Customer/Vendor Name" := Cust.Name;
                    if Cust."Currency Code" <> '' then
                        DepositEntry."Currency Factor" := ExchangeCurrency.ExchangeRate(DepositEntry."Posting Date", Cust."Currency Code");
                    //   DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * (1 / DepositEntry."Currency Factor");
                    //   DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * (1 / DepositEntry."Currency Factor");

                    DepositEntry."Currency Code" := Cust."Currency Code";
                end;
                DepositEntry.Type := GenJnlLine."TPP Deposit Type";
                DepositEntry."Customer/Vendor No." := GenJnlLine."TPP Deposit Type No.";
                DepositEntry.Description := GenJnlLine.Description;
                DepositEntry."Clear Deposit" := GenJnlLine."TPP Clear Deposit";
                DepositEntry.Insert();
            until GenJnlLine.next() = 0;

    end;

    /// <summary>
    /// TPP CreateDepositPurchaseEntry.
    /// </summary>
    /// <param name="PurchLine">Record "Purchase Line".</param>
    procedure "TPP CreateDepositPurchaseEntry"(PurchLine: Record "Purchase Line")
    var
        DepositEntry: Record "TPP Deposit Entry";
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.GET(PurchLine."Document Type", PurchLine."Document No.");
        if PurchLine."TPP Deposit" then begin
            DepositEntry.Init();
            DepositEntry."Entry No." := DepositEntry."TPP GetLastLine"();
            DepositEntry."Document No." := PurchLine."Document No.";
            DepositEntry."G/L Account No." := PurchLine."No.";
            DepositEntry.Amount := PurchLine.Amount;
            DepositEntry."Amount Include Vat" := PurchLine."Amount Including VAT";
            DepositEntry."Amount (LCY)" := PurchLine.Amount;
            DepositEntry."Amount Include Vat (LCY)" := PurchLine."Amount Including VAT";
            DepositEntry."Currency Code" := PurchaseHeader."Currency Code";
            DepositEntry."Currency Factor" := PurchaseHeader."Currency Factor";
            DepositEntry."Posting Date" := PurchaseHeader."Posting Date";
            DepositEntry."Document Date" := PurchaseHeader."Document Date";
            DepositEntry."External Document No." := PurchaseHeader."Vendor Invoice No.";
            DepositEntry."Ref. Document Line No." := PurchLine."Line No.";
            DepositEntry."Customer/Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
            DepositEntry."Customer/Vendor No." := PurchaseHeader."Buy-from Vendor No.";
            DepositEntry.Description := PurchLine.Description;
            DepositEntry."Vat Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
            DepositEntry."Vat Prod. Posting Group" := PurchLine."Vat Prod. Posting Group";
            DepositEntry.Type := DepositEntry.Type::Vendor;
            DepositEntry."Clear Deposit" := PurchLine."TPP Clear Deposit";
            if DepositEntry."Currency Code" <> '' then begin
                DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * (1 / DepositEntry."Currency Factor");
                DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * (1 / DepositEntry."Currency Factor");
            end;
            if PurchLine."Document Type" = PurchLine."Document Type"::Invoice then
                DepositEntry."Document Type" := DepositEntry."Document Type"::"Purchase Invoice";

            if PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo" then begin
                DepositEntry."Document Type" := DepositEntry."Document Type"::"Purchase Credit Memo";
                DepositEntry.Amount := DepositEntry.Amount * -1;
                DepositEntry."Amount Include Vat" := DepositEntry."Amount Include Vat" * -1;
                DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * -1;
                DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * -1;
                DepositEntry."Clear Deposit" := true;
            end;
            DepositEntry.Insert();
        end;
    end;

    /// <summary>
    /// TPP CreateDepositSalesEntry.
    /// </summary>
    /// <param name="SalesLine">Record "Sales Line".</param>
    procedure "TPP CreateDepositSalesEntry"(SalesLine: Record "Sales Line")
    var
        DepositEntry: Record "TPP Deposit Entry";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        if SalesLine."TPP Deposit" then begin
            DepositEntry.Init();
            DepositEntry."Entry No." := DepositEntry."TPP GetLastLine"();
            DepositEntry."Document No." := SalesLine."Document No.";
            DepositEntry."G/L Account No." := SalesLine."No.";
            DepositEntry.Amount := SalesLine.Amount;
            DepositEntry."Amount Include Vat" := SalesLine."Amount Including VAT";
            DepositEntry."Amount (LCY)" := SalesLine.Amount;
            DepositEntry."Amount Include Vat (LCY)" := SalesLine."Amount Including VAT";
            DepositEntry."Currency Code" := SalesHeader."Currency Code";
            DepositEntry."Currency Factor" := SalesHeader."Currency Factor";
            DepositEntry."Posting Date" := SalesHeader."Posting Date";
            DepositEntry."Document Date" := SalesHeader."Document Date";
            DepositEntry."External Document No." := SalesHeader."External Document No.";
            DepositEntry."Ref. Document Line No." := SalesLine."Line No.";
            DepositEntry."Customer/Vendor Name" := SalesHeader."Sell-to Customer Name";
            DepositEntry."Customer/Vendor No." := SalesHeader."Sell-to Customer No.";
            DepositEntry.Description := SalesLine.Description;
            DepositEntry."Clear Deposit" := SalesLine."TPP Clear Deposit";
            DepositEntry."Vat Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
            DepositEntry."Vat Prod. Posting Group" := SalesLine."Vat Prod. Posting Group";
            DepositEntry.Type := DepositEntry.Type::Customer;
            if DepositEntry."Currency Code" <> '' then begin
                DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * (1 / DepositEntry."Currency Factor");
                DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * (1 / DepositEntry."Currency Factor");
            end;
            if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                DepositEntry."Document Type" := DepositEntry."Document Type"::"Sales Invoice";


            if SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" then begin
                DepositEntry."Document Type" := DepositEntry."Document Type"::"Sales Credit Memo";
                DepositEntry.Amount := DepositEntry.Amount * -1;
                DepositEntry."Amount Include Vat" := DepositEntry."Amount Include Vat" * -1;
                DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * -1;
                DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * -1;
                DepositEntry."Clear Deposit" := true;
            end;

            DepositEntry.Insert();
        end;
    end;



    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure TPPOnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text)
    var

        DepositEntry: Record "TPP Deposit Entry";
    begin
        if TableID = Database::"TPP Deposit Entry" then begin
            DepositEntry.Reset();
            DepositEntry.SetFilter("Document No.", DocNoFilter);
            DepositEntry.SetFilter("Posting Date", PostingDateFilter);
            PAGE.RUN(PAGE::"TPP Deposit Entry", DepositEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure TPPOnAfterNavigateFindRecords(sender: Page Navigate; DocNoFilter: Text; PostingDateFilter: Text; var DocumentEntry: Record "Document Entry")
    var
        DepositEntry: Record "TPP Deposit Entry";
    begin

        if DepositEntry.ReadPermission() then begin
            DepositEntry.Reset();
            DepositEntry.SetFilter("Document No.", DocNoFilter);
            DepositEntry.SetFilter("Posting Date", PostingDateFilter);
            sender.InsertIntoDocEntry(DocumentEntry, DATABASE::"TPP Deposit Entry", 'Deposit Entry', DepositEntry.Count);
        end;

    end;



}