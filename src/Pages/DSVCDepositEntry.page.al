/// <summary>
/// Page DSVC Deposit Entry (ID 70500).
/// </summary>
Page 70500 "DSVC Deposit Entry"
{
    Caption = 'Deposit Entry';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "DSVC Deposit Entry";
    SourceTableView = sorting("Entry No.");
    UsageCategory = Lists;
    PageType = List;
    ApplicationArea = all;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Document Type';
                }
                field("G/L Account No."; rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies G/L Account No.';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Posting Date';
                }
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Document Date';
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Document No.';
                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Customer/Vendor No.';
                }
                field("Customer/Vendor Name"; rec."Customer/Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Customer/Vendor Name';
                }
                field("Vat Prod. Posting Group"; rec."Vat Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Vat Prod. Posting Group';
                }
                field("Vat Bus. Posting Group"; rec."Vat Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Vat Bus. Posting Group';
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies ';
                }
                field("External Document No."; rec."External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies External Document No.';
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Currency Code';
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount';
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount (LCY)';
                }
                field("Amount Include Vat"; rec."Amount Include Vat")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount Include Vat';
                }
                field("Amount Include Vat (LCY)"; rec."Amount Include Vat (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Amount Include Vat (LCY)';
                }
                field("Clear Deposit"; rec."Clear Deposit")
                {
                    ApplicationArea = all;
                    ToolTip = 'Spacifies Clear Deposit';
                }

            }
        }
    }
}