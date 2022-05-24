/// <summary>
/// Codeunit DSVC Deposit Func (ID 70500).
/// </summary>
codeunit 70500 "DSVC Deposit Func"
{

    /// <summary>
    /// GetDepositEntry.
    /// </summary>
    /// <param name="pDepositType">Enum "DSVC Deposit Type".</param>
    /// <param name="pTemplateName">Code[10].</param>
    /// <param name="pDocumentNo">Code[30].</param>
    /// <param name="pVendorCoustomerNo">Code[20].</param>
    /// <param name="pBatchName">code[30].</param>

    procedure GetDepositEntry(pDepositType: Enum "DSVC Deposit Type"; pTemplateName: Code[10]; pDocumentNo: Code[30]; pVendorCoustomerNo: Code[20]; pBatchName: code[30])
    var
        DepositEntry: Record "DSVC Deposit Entry";
        GetDeposit: Page "DSVC Get Deposit Entry";
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
    local procedure DSVCOnBeforeCode(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenLine: Record "Gen. Journal Line";

    begin
        GenLine.Reset();
        GenLine.copy(GenJnlLine);
        GenLine.SetRange("DSVC Deposit", true);
        GenLine.SetRange("DSVC From Genjournal Line", true);
        if GenLine.FindSet() then
            repeat
                GenLine.TestField("DSVC Deposit Type No.");
            until GenLine.next() = 0;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure DSVCOnAfterInitFromPurchInvoiceLine(PurchLine: Record "Purchase Line")

    begin
        "DSVC CreateDepositPurchaseEntry"(PurchLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Cr. Memo Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure DSVCOnAfterInitFromPurchCNLine(PurchLine: Record "Purchase Line")

    begin
        "DSVC CreateDepositPurchaseEntry"(PurchLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure DSVCOnAfterInitFromSalesInvoiceLine(SalesLine: Record "Sales Line")

    begin
        "DSVC CreateDepositSalesEntry"(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesCNLine(SalesLine: Record "Sales Line")

    begin
        "DSVC CreateDepositSalesEntry"(SalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeUpdateAndDeleteLines', '', false, false)]
    local procedure DSVCOnBeforeUpdateAndDeleteLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        DepositEntry: Record "DSVC Deposit Entry";
        GenjournalTemplate: Record "Gen. Journal Template";
        Vend: Record Vendor;
        Cust: Record Customer;
        ExchangeCurrency: Record "Currency Exchange Rate";

    begin
        GenjournalTemplate.GET(GenJournalLine."Journal Template Name");
        GenJnlLine.Reset();
        GenJnlLine.Copy(GenJournalLine);
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        GenJnlLine.SetRange("DSVC Deposit", true);
        if GenJnlLine.FindSet(true, false) then
            repeat
                DepositEntry.Init();
                DepositEntry."Entry No." := DepositEntry."DSVC GetLastLine"();
                DepositEntry."Document No." := GenJnlLine."Document No.";
                DepositEntry."G/L Account No." := GenJnlLine."Account No.";
                if NOT GenJnlLine."DSVC Clear Deposit" then begin
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
                if GenJnlLine."DSVC Deposit Type" = GenJnlLine."DSVC Deposit Type"::Vendor then begin
                    Vend.GET(GenJnlLine."DSVC Deposit Type No.");
                    DepositEntry."Customer/Vendor Name" := Vend.Name;
                    if Vend."Currency Code" <> '' then
                        DepositEntry."Currency Factor" := ExchangeCurrency.ExchangeRate(DepositEntry."Posting Date", Vend."Currency Code");
                    //  DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * (1 / DepositEntry."Currency Factor");
                    //   DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * (1 / DepositEntry."Currency Factor");

                    DepositEntry."Currency Code" := Vend."Currency Code";
                end else begin
                    Cust.GET(GenJnlLine."DSVC Deposit Type No.");
                    DepositEntry."Customer/Vendor Name" := Cust.Name;
                    if Cust."Currency Code" <> '' then
                        DepositEntry."Currency Factor" := ExchangeCurrency.ExchangeRate(DepositEntry."Posting Date", Cust."Currency Code");
                    //   DepositEntry."Amount (LCY)" := DepositEntry."Amount (LCY)" * (1 / DepositEntry."Currency Factor");
                    //   DepositEntry."Amount Include Vat (LCY)" := DepositEntry."Amount Include Vat (LCY)" * (1 / DepositEntry."Currency Factor");

                    DepositEntry."Currency Code" := Cust."Currency Code";
                end;
                DepositEntry."Customer/Vendor No." := GenJnlLine."DSVC Deposit Type No.";
                DepositEntry.Description := GenJnlLine.Description;
                DepositEntry."Clear Deposit" := GenJnlLine."DSVC Clear Deposit";
                DepositEntry.Insert();
            until GenJnlLine.next() = 0;

    end;

    /// <summary>
    /// DSVC CreateDepositPurchaseEntry.
    /// </summary>
    /// <param name="PurchLine">Record "Purchase Line".</param>
    procedure "DSVC CreateDepositPurchaseEntry"(PurchLine: Record "Purchase Line")
    var
        DepositEntry: Record "DSVC Deposit Entry";
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.GET(PurchLine."Document Type", PurchLine."Document No.");
        if PurchLine."DSVC Deposit" then begin
            DepositEntry.Init();
            DepositEntry."Entry No." := DepositEntry."DSVC GetLastLine"();
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
            DepositEntry."Clear Deposit" := PurchLine."DSVC Clear Deposit";
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
    /// DSVC CreateDepositSalesEntry.
    /// </summary>
    /// <param name="SalesLine">Record "Sales Line".</param>
    procedure "DSVC CreateDepositSalesEntry"(SalesLine: Record "Sales Line")
    var
        DepositEntry: Record "DSVC Deposit Entry";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        if SalesLine."DSVC Deposit" then begin
            DepositEntry.Init();
            DepositEntry."Entry No." := DepositEntry."DSVC GetLastLine"();
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
            DepositEntry."Clear Deposit" := SalesLine."DSVC Clear Deposit";
            DepositEntry."Vat Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
            DepositEntry."Vat Prod. Posting Group" := SalesLine."Vat Prod. Posting Group";
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
    local procedure DSVCOnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text)
    var

        DepositEntry: Record "DSVC Deposit Entry";
    begin
        if TableID = Database::"DSVC Deposit Entry" then begin
            DepositEntry.Reset();
            DepositEntry.SetFilter("Document No.", DocNoFilter);
            DepositEntry.SetFilter("Posting Date", PostingDateFilter);
            PAGE.RUN(PAGE::"DSVC Deposit Entry", DepositEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure DSVCOnAfterNavigateFindRecords(sender: Page Navigate; DocNoFilter: Text; PostingDateFilter: Text; var DocumentEntry: Record "Document Entry")
    var
        DepositEntry: Record "DSVC Deposit Entry";
    begin

        if DepositEntry.ReadPermission() then begin
            DepositEntry.Reset();
            DepositEntry.SetFilter("Document No.", DocNoFilter);
            DepositEntry.SetFilter("Posting Date", PostingDateFilter);
            sender.InsertIntoDocEntry(DocumentEntry, DATABASE::"DSVC Deposit Entry", 'Deposit Entry', DepositEntry.Count);
        end;

    end;



}