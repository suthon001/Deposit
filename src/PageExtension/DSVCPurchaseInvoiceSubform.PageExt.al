/// <summary>
/// PageExtension DSVC PurchaseInvoice Subform (ID 70500).
/// </summary>
pageextension 70500 "DSVC PurchaseInvoice Subform" extends "Purch. Invoice Subform"
{
    actions
    {
        addlast("F&unctions")
        {
            action("DSVC GetDeposit")
            {
                Caption = 'Get Deposit Lines';
                Image = DepositLines;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Get Deposit Lines';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    DepositFunc: Codeunit "DSVC Deposit Func";
                    DepositType: Enum "DSVC Deposit Type";

                begin
                    PurchaseHeader.GET(rec."Document Type", rec."Document No.");
                    PurchaseHeader.TestField(status, PurchaseHeader.Status::Open);
                    DepositFunc.GetDepositEntry(DepositType::"Purchase Invoice", '', rec."Document No.", PurchaseHeader."Buy-from Vendor No.", '');
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        ltDeposit: Record "DSVC Deposit Entry";
    begin
        if ltDeposit.GET(rec."DSVC Ref. Deposit Entry No.") then begin
            ltDeposit.Used := false;
            ltDeposit."Ref. Batch Name" := '';
            ltDeposit."Ref. Document Line No." := 0;
            ltDeposit."Ref. Template Name" := '';
            ltDeposit.Modify();
        end;
    end;
}