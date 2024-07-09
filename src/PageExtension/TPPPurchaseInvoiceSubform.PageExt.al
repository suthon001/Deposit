/// <summary>
/// PageExtension TPP PurchaseInvoice Subform (ID 70500).
/// </summary>
pageextension 70500 "TPP PurchaseInvoice Subform" extends "Purch. Invoice Subform"
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
                    PurchaseHeader: Record "Purchase Header";
                    DepositFunc: Codeunit "TPP Deposit Func";
                    DepositType: Enum "TPP Deposit Type";

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