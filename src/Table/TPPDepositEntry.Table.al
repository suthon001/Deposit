/// <summary>
/// Table TPP Deposit Entry (ID 70500).
/// </summary>
table 70500 "TPP Deposit Entry"
{
    LookupPageId = "TPP Deposit Entry";
    DrillDownPageId = "TPP Deposit Entry";

    Caption = 'Deposit Entry';
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Document Type"; Enum "TPP Deposit Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(3; "Document No."; Code[30])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(5; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(6; "Customer/Vendor No."; Code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
        }
        field(7; "Customer/Vendor Name"; Text[100])
        {
            Caption = 'Customer/Vendor Name';
            DataClassification = CustomerContent;
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(9; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Amount Include Vat"; Decimal)
        {
            Caption = 'Amount Include VAT';
            DataClassification = CustomerContent;
        }
        field(12; "Amount Include Vat (LCY)"; Decimal)
        {
            Caption = 'Amount Include (LCY)';
            DataClassification = CustomerContent;
        }
        field(13; "Ref. Document Line No."; Integer)
        {
            Caption = 'Ref. Document Line No.';
            DataClassification = CustomerContent;
        }
        field(14; "Ref. Template Name"; Text[20])
        {
            Caption = 'Ref. Template Name';
            DataClassification = CustomerContent;
        }
        field(15; "Ref. Batch Name"; Text[20])
        {
            Caption = 'Ref. Batch Name';
            DataClassification = CustomerContent;
        }
        field(16; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(17; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(18; "External Document No."; Text[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(19; Used; Boolean)
        {
            Caption = 'Used';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(21; "Clear Deposit"; Boolean)
        {
            Caption = 'Clear Deposit';
            DataClassification = CustomerContent;
        }
        field(22; "Vat Prod. Posting Group"; Code[20])
        {
            Caption = 'Vat Prod. Posting Group';
            DataClassification = CustomerContent;
        }
        field(23; "Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            DataClassification = CustomerContent;
        }
        field(24; "Type"; Enum "TPP Deposit Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK1; "Entry No.")
        {
            Clustered = true;
        }
    }
    /// <summary>
    /// TPP GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure "TPP GetLastLine"(): Integer
    var
        DepositEntry: Record "TPP Deposit Entry";
    begin
        DepositEntry.Reset();
        DepositEntry.SetCurrentKey("Entry No.");
        if DepositEntry.FindLast() then
            exit(DepositEntry."Entry No." + 1);
        exit(1);
    end;

}