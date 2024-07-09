/// <summary>
/// Codeunit TPP PreviewPosting Deposit (ID 70501).
/// </summary>
codeunit 70501 "TPP PreviewPosting Deposit"
{
    SingleInstance = true;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
    local procedure TPPOnAfterFillDocumentEntry(var DocumentEntry: Record "Document Entry");
    var
        PostingPreview: Codeunit "Posting Preview Event Handler";

    begin

        PostingPreview.InsertDocumentEntry(TempDepositEntry, DocumentEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', false, false)]
    local procedure TPPOnAfterShowEntries(TableNo: Integer);
    begin
        if TableNo = Database::"TPP Deposit Entry" then
            PAGE.RUN(PAGE::"TPP Show Deposit Entry", TempDepositEntry);
    end;

    [EventSubscriber(ObjectType::table, Database::"TPP Deposit Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure TPPOnAfterInsertEventDeposit(var Rec: Record "TPP Deposit Entry"; RunTrigger: Boolean);
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
    local procedure TPPOnBeforeRunPreview()
    begin
        TempDepositEntry.reset();
        TempDepositEntry.DeleteAll();
    end;

    var
        TempDepositEntry: Record "TPP Deposit Entry" temporary;
}
