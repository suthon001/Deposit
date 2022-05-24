/// <summary>
/// Codeunit DSVC PreviewPosting Deposit (ID 70501).
/// </summary>
codeunit 70501 "DSVC PreviewPosting Deposit"
{
    SingleInstance = true;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
    local procedure DSVCOnAfterFillDocumentEntry(var DocumentEntry: Record "Document Entry");
    var
        PostingPreview: Codeunit "Posting Preview Event Handler";

    begin

        PostingPreview.InsertDocumentEntry(TempDepositEntry, DocumentEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', false, false)]
    local procedure DSVCOnAfterShowEntries(TableNo: Integer);
    begin
        if TableNo = Database::"DSVC Deposit Entry" then
            PAGE.RUN(PAGE::"DSVC Show Deposit Entry", TempDepositEntry);
    end;

    [EventSubscriber(ObjectType::table, Database::"DSVC Deposit Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure DSVCOnAfterInsertEventDeposit(var Rec: Record "DSVC Deposit Entry"; RunTrigger: Boolean);
    var
        PostingPreview: Codeunit "Posting Preview Event Handler";
    begin
        IF Rec.ISTEMPORARY THEN
            EXIT;
        PostingPreview.PreventCommit();
        TempDepositEntry := Rec;
        TempDepositEntry."Document No." := '***';
        TempDepositEntry.INSERT();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnBeforeRunPreview', '', false, false)]
    local procedure DSVCOnBeforeRunPreview()
    begin
        TempDepositEntry.reset();
        TempDepositEntry.DeleteAll();
    end;

    var
        TempDepositEntry: Record "DSVC Deposit Entry" temporary;
}
