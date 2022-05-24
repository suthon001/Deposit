

/// <summary>
/// PageExtension DSVC SalesInvoice Subform (ID 70501) extends Record Sales Invoice Subform.
/// </summary>
pageextension 70501 "DSVC SalesInvoice Subform" extends "Sales Invoice Subform"
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
                    SalesHeader: Record "Sales Header";
                    DepositFunc: Codeunit "DSVC Deposit Func";
                    DepositType: Enum "DSVC Deposit Type";

                begin
                    SalesHeader.GET(rec."Document Type", rec."Document No.");
                    SalesHeader.TestField(status, SalesHeader.Status::Open);
                    DepositFunc.GetDepositEntry(DepositType::"Sales Invoice", '', rec."Document No.", SalesHeader."Sell-to Customer No.", '');
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