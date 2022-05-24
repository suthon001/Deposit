/// <summary>
/// PageExtension DSVC Payment Journal (ID 70502) extends Record Payment Journal.
/// </summary>
pageextension 70502 "DSVC Payment Journal" extends "Payment Journal"
{
    layout
    {
        addafter("Gen. Posting Type")
        {
            field("DSVC Deposit"; rec."DSVC Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Depost';
            }
            field("DSVC Deposit Type"; rec."DSVC Deposit Type")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Type';
            }
            field("DSVC Deposit Type No."; rec."DSVC Deposit Type No.")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Deposit Type No.';
            }
        }
    }
    actions
    {
        addafter(ApplyEntries)
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
                    DepositFunc: Codeunit "DSVC Deposit Func";
                    DepositType: Enum "DSVC Deposit Type";
                begin
                    rec.TestField("Account Type", rec."Account Type"::Vendor);
                    DepositFunc.GetDepositEntry(DepositType::"Payment Journal", rec."Journal Template Name", rec."Document No.", rec."Account No.", rec."Journal Batch Name");
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