

/// <summary>
/// PageExtension TPP SalesInvoice Subform (ID 70501) extends Record Sales Invoice Subform.
/// </summary>
pageextension 70501 "TPP SalesInvoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Description 2")
        {
            field("TPP Deposit"; rec."TPP Deposit")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("TPP GetDeposit")
            {
                Caption = 'Get Deposit Lines';
                Image = DepositLines;
                ApplicationArea = all;
                ToolTip = 'Get Deposit Lines';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    DepositFunc: Codeunit "TPP Deposit Func";
                    DepositType: Enum "TPP Deposit Document Type";

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
        ltDeposit: Record "TPP Deposit Entry";
    begin
        if ltDeposit.GET(rec."TPP Ref. Deposit Entry No.") then begin
            ltDeposit.Used := false;
            ltDeposit."Ref. Batch Name" := '';
            ltDeposit."Ref. Document Line No." := 0;
            ltDeposit."Ref. Template Name" := '';
            ltDeposit.Modify();
        end;
    end;
}