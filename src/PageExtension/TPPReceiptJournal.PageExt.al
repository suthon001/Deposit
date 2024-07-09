
/// <summary>
/// PageExtension TPP Receipt Journal (ID 70503) extends Record Cash Receipt Journal.
/// </summary>
pageextension 70503 "TPP Receipt Journal" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Gen. Posting Type")
        {
            field("TPP Deposit"; rec."TPP Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Depost';
            }
            field("TPP Deposit Type"; rec."TPP Deposit Type")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Type';
            }
            field("TPP Deposit Type No."; rec."TPP Deposit Type No.")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Type No.';
            }
        }
    }
    actions
    {
        addafter("Apply Entries")
        {
            action("TPP GetDeposit")
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
                    DepositFunc: Codeunit "TPP Deposit Func";
                    DepositType: Enum "TPP Deposit Type";
                begin
                    rec.TestField("Account Type", rec."Account Type"::Customer);
                    DepositFunc.GetDepositEntry(DepositType::"Cash Receipt", rec."Journal Template Name", rec."Journal Batch Name", rec."Account No.", rec."Journal Batch Name");
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